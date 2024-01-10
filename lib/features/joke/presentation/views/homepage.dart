import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../provider/joke_provider.dart';
import '../widgets/row_buttons.dart';
import '../widgets/joke_card.dart';

import 'jokespage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final provider = context.watch<JokeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jokes Aside',
          style: TextStyle(
            fontWeight: FontWeight.w600,
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
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          height: size.width * 0.7,
          child: RepaintBoundary(
            key: _globalKey,
            child: (provider.jokeEntity != null)
                ? JokeCard(
                    joke: provider.jokeEntity!.setup,
                    punchline: provider.jokeEntity!.punchline,
                  )
                : (provider.failure != null)
                    ? Text(provider.failure!.errorMessage)
                    : const Center(child: CircularProgressIndicator()
                        // child: Text('No Joke Yet'),
                        ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.eitherFailureOrJokes(endpoint: 'any'),
        child: const Icon(CupertinoIcons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: SizedBox(
        height: 50.0,
        child: Row(
          children: [
            RowButton(
              title: 'Share',
              icon: CupertinoIcons.share,
              onPressed: () async {
                try {
                  final boundary = _globalKey.currentContext!.findRenderObject()
                      as RenderRepaintBoundary;
                  final image = await boundary.toImage(pixelRatio: 3);
                  final byteData =
                      await image.toByteData(format: ImageByteFormat.png);
                  final pngBytes = byteData!.buffer.asUint8List();

                  // Use path_provider to create a temporary file
                  final tempDir = await getTemporaryDirectory();
                  final file = File('${tempDir.path}/joke-aside.png');
                  await file.writeAsBytes(pngBytes);

                  // Prompt user to select a save location
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

                  // await Share.shareXFiles([XFile(file.path)]);
                } on Exception catch (e) {
                  debugPrint('error: $e');
                }
              },
            ),
            RowButton(
              title: 'Bookmark',
              icon: CupertinoIcons.bookmark,
              onPressed: () => null,
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
}




/* onPressed: () async {
          try {
            final boundary = _globalKey.currentContext!.findRenderObject()
                as RenderRepaintBoundary;
            final image = await boundary.toImage(pixelRatio: 3);
            final byteData =
                await image.toByteData(format: ImageByteFormat.png);
            final pngBytes = byteData!.buffer.asUint8List();

            // Use path_provider to create a temporary file
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/joke-aside.png');
            await file.writeAsBytes(pngBytes);

            // Prompt user to select a save location
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

            // await Share.shareXFiles([XFile(file.path)]);
          } on Exception catch (e) {
            debugPrint('error: $e');
          }
        }, */