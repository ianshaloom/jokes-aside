import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme/text_schemes.dart';

class CustomIconBtn extends StatelessWidget {
  final String title;
  final Function onPressed;
  final String svgPath;
  final String svgPathDark;
  const CustomIconBtn(
      {super.key,
      required this.onPressed,
      required this.svgPath,
      required this.svgPathDark,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    final sysTheme = Theme.of(context).brightness;

    final String svg = sysTheme == Brightness.light ? svgPath : svgPathDark;

    return Column(
      children: [
        InkWell(
          onTap: () => onPressed(),
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 27,
            backgroundColor: color.onSurface.withOpacity(0.1),
            child: Center(
              child: SvgPicture.asset(
                svg,
                height: 30,
              ),
            ),
          ),
        ),
        title != '' ? const SizedBox(height: 10) : const Center(),
        title != ''
            ? Text(
                title,
                textAlign: TextAlign.center,
                style: bodyDefault(textTheme),
              )
            : const Center(),
        title == '' ? const SizedBox(height: 10) : const Center(),
      ],
    );
  }
}
