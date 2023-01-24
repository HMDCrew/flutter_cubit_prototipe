import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/banners_cubit.dart';
import '../utils/home/home_slide.dart';
import '../utils/placeholder.dart';
import '../utils/slide.dart';
import '../utils/slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocBuilder<BannersCubit, BannersState>(
          builder: (_, state) {
            if (state is BannersLoaded) {
              return MySlider(slides: loadHomeSlides(state.banners));
            }

            if (state is ErrorBanners) {
              return Text(state.message);
            }

            // loading placeholder
            WPRPlaceholder slidePlace = const WPRPlaceholder(
              wrapColumn: false,
              content: MySlide(content: Text('')),
            );

            return MySlider(slides: <Widget>[
              slidePlace,
              slidePlace,
              slidePlace,
              slidePlace
            ]);
          },
        ),
      ],
    );
  }

  List<MySlide> loadHomeSlides(banners) {
    List<MySlide> slides = <MySlide>[];

    for (final slide in banners) {
      if (slide['include_metas']['banner_text'] != '') {
        if (slide['image'] != false) {
          slides.add(MySlide(
              content: HomeSlide(slide: slide),
              backgroundImage: slide['image']));
        } else {
          slides.add(MySlide(content: HomeSlide(slide: slide)));
        }
      }
    }
    return slides;
  }
}
