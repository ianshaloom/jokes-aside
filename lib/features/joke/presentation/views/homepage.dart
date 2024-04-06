import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/connection/network_info.dart';
import '../provider/joke_provider.dart';
import '../widgets/arrow_svg_widget.dart';
// import '../widgets/joke_card.dart';
import '../widgets/joke_card.dart';
import '../widgets/no_internet.dart';
import '../widgets/row_button.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _globalKey = GlobalKey();
  final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    final provider = context.watch<JokeProvider>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Spacer(),
              Center(
                child: SizedBox(
                  width: size.width * 0.9,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : (provider.jokeEntity != null)
                            ? JokeCard(
                                joke: provider.jokeEntity!.setup,
                                punchline: provider.jokeEntity!.punchline,
                              )
                            : (provider.failure != null)
                                ? Text(
                                    'Something went wrong',
                                    textAlign: TextAlign.center,
                                    style: textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: color.error,
                                      fontFamily: 'Gilroy',
                                    ),
                                  )
                                : const Center(
                                    child: ArrowSvg(),
                                    // child: Text('No Joke Yet'),
                                  ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StreamBuilder(
              stream: networkInfo.onStatusChange,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final isConnected = snapshot.data;
                  if (isConnected == DataConnectionStatus.connected) {
                    JokeProvider.isConnected = true;
                    return const SizedBox(
                      height: 100,
                    );
                  }

                  JokeProvider.isConnected = false;
                  return const NoInternet();
                }
                return const Center();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        // elevation: 1,
        label: const Text(
          'Get Joke',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: () => provider.eitherFailureOrJokeEntity(endpoint: 'any'),
        icon: const Icon(CupertinoIcons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 50.0,
        child: Row(
          children: [
            const SaveButton(),
            ShareButton(
              onPressed: () =>
                  (provider.isLoading || provider.jokeEntity == null)
                      ? null
                      : _share(),
            ),
            const ListButton(),

            // If a location is selected, save the
          ],
        ),
      ),
    );
  }

  Widget _jokeCard(BuildContext context, String joke, String punchline) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            joke,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium!.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              const SizedBox(height: 8),
              Text(
                '~ $punchline',
                style: textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Gilroy',
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _share() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Use path_provider to create a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/joke-aside.png');
      await file.writeAsBytes(pngBytes);

      // await Share.shareXFiles([XFile(file.path)]);
      await Share.shareXFiles([XFile(file.path)]);
    } on Exception catch (e) {
      debugPrint('error: $e');
    }
  }
}
