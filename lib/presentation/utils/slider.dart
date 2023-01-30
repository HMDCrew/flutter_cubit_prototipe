import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MySlider extends StatelessWidget {
  final List<Widget> slides;
  final bool isColumn;
  final double height;
  final dynamic dotsEffect;

  MySlider(
      {Key? key,
      required this.slides,
      this.isColumn = true,
      this.height = 250,
      this.dotsEffect = const ExpandingDotsEffect(
          activeDotColor: Color.fromARGB(255, 255, 255, 255))})
      : super(key: key);

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {

    List<Widget> content = <Widget>[
        SizedBox(
          height: height,
          child: PageView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: pageController,
            children: slides,
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: slides.length,
          effect: dotsEffect,
        )
      ];

    return isColumn ? Column(children: content) : Stack(alignment: AlignmentDirectional.bottomCenter, children: content);
  }
}
