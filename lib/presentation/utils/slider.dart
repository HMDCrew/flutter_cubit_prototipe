import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MySlider extends StatelessWidget {
  final List<Widget> slides;
  final double height;
  final dynamic dotsEffect;

  MySlider(
      {Key? key,
      required this.slides,
      this.height = 250,
      this.dotsEffect = const ExpandingDotsEffect(
          activeDotColor: Color.fromARGB(255, 255, 255, 255))})
      : super(key: key);

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
      ],
    );
  }
}
