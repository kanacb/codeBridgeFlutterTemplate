import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildSvgIcon extends StatelessWidget {
   BuildSvgIcon({
    super.key,
    required this.assetName,
    required this.index,
    required this.currentIndex,
     this.width,
     this.height
  });
  final String assetName;
  final int index;
  final int currentIndex;
   double? width   ;
   double? height;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SvgPicture.asset(
      assetName,
      color: currentIndex == index ? Colors.red : Colors.grey,
      width: width ?? 24,
      height: height ?? 24,
    );
  }
}
