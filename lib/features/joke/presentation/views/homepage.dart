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
import '../widgets/row_button.dart';

import 'jokespage.dart';

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
        title: const Text(
          'Jokes Aside',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const JokesPage();
              }));
            },
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: networkInfo.onStatusChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final isConnected = snapshot.data;
                if (isConnected == DataConnectionStatus.connected) {
                  return const SizedBox(
                    height: 100,
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: color.tertiaryContainer,
                    contentPadding: const EdgeInsets.all(10),
                    leading: Icon(
                      CupertinoIcons.wifi_slash,
                      color: color.error,
                    ),
                    title: Text(
                      'Check your Wi-Fi or network connection settings make sure you are connected',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w300,
                            color: color.onTertiaryContainer,
                          ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Center(
            child: SizedBox(
              width: size.width * 0.9,
              child: RepaintBoundary(
                key: _globalKey,
                child: (provider.jokeEntity != null)
                    ? _jokeCard(context, provider.jokeEntity!.setup,
                        provider.jokeEntity!.punchline)
                    : (provider.failure != null)
                        ? Text(
                            'Something went wrong',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color.error,
                            ),
                          )
                        : const Center(
                            child: ArrowSvg(),
                            // child: Text('No Joke Yet'),
                          ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        // elevation: 1,
        label: const Text('Get Joke'),
        onPressed: () => provider.eitherFailureOrJokeEntity(endpoint: 'any'),
        icon: const Icon(CupertinoIcons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: SizedBox(
        height: 50.0,
        child: Row(
          children: [
            RowButton(
              isBookmark: false,
              title: 'Share',
              onPressed: () => share(),
            ),
            const RowButton(
              isBookmark: true,
              title: 'Bookmark',
            ), /* 
            RowButton(
              title: 'Save',
              icon: CupertinoIcons.delete,
              onPressed: () => null,
            ), */

            // If a location is selected, save the
          ],
        ),
      ),
    );
  }

  Widget _jokeCard(BuildContext context, String joke, String punchline) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // borderRadius: BorderRadius.circular(10),
      ),
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
                punchline,
                style: textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void share() async {
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
/*  // Prompt user to select a save location
      final savePath = await FilePicker.platform.saveFile(
        type: FileType.image,
        allowedExtensions: ['png'],
        fileName: 'joke-aside.png',
        initialDirectory: tempDir.path,
        dialogTitle: 'Save Joke Aside',
      );

      // If a location is selected, save the image
      if (savePath != null) {
        final file = File(savePath);
        await file.writeAsBytes(pngBytes);
      }
       */