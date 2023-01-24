import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WPRPlaceholder extends StatelessWidget {
  final dynamic content;
  final double width;
  final double height;
  final bool wrapColumn;
  const WPRPlaceholder({Key? key, this.wrapColumn = true, this.width = 200, this.height = 100, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Shimmer animation = Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 158, 158, 158),
      highlightColor: const Color.fromARGB(255, 175, 175, 175),
      child: content ?? const DecoratedBox(
        decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
        child: SizedBox(),
      ),
    );

    SizedBox box = SizedBox(
      width: width,
      height: height,
      child: animation,
    );

    return wrapColumn ? Column(children: [box]) : box;
  }
}
