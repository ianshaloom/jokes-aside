import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class EmptySvg extends StatelessWidget {
  const EmptySvg({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final size = MediaQuery.of(context).size;
    final height = size.height * 0.4;
    final width = size.width * 0;


    return brightness == Brightness.light
        ? SvgPicture.asset(
            'assets/images/empty-light.svg',
            width: width,
            height: height,
          )
        : SvgPicture.asset(
            'assets/images/empty-dark.svg',
            width: width,
            height: height,
          );
  }
}