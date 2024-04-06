import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jokes_aside/features/joke/domain/jokes_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/constant.dart';
import 'custom_icon_btn.dart';
import 'joke_card.dart';

class JokeDialog extends StatelessWidget {
  final JokeEntity joke;
  final _globalKey = GlobalKey();

  JokeDialog({super.key, required this.joke});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 400,
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: _globalKey,
                child: JokeCard(
                  joke: joke.setup,
                  punchline: joke.punchline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconBtn(
                    svgPath: share,
                    svgPathDark: shareDark,
                    onPressed: _share,
                    title: '',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _share() async {
    print('--------------------share');
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
