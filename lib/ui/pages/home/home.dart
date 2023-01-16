import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/banners/banners_cubit.dart' as bannerCubit;
import '../../../states_management/banners/banners_state.dart' as bannerState;
import '../../../states_management/taxonomy/taxonomy_cubit.dart';
import '../../utils/inc/placeholder.dart';
import '../../utils/inc/slide.dart';
import '../../utils/slider.dart';
import 'home_slide.dart';

class Home extends StatefulWidget {
  final List? banners = [];
  Home({Key? key, List? banners}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bannerState.PageLoaded? bannerLoaded;
  late TaxonomyCubit taxonomyBloc;

  @override
  void initState() {
    if( widget.banners!.isEmpty ) {
      BlocProvider.of<bannerCubit.BannerCubit>(context).getBanners(
          page: 0, includeMetas: '[banner_text, color_title, click_through_url]');
      BlocProvider.of<TaxonomyCubit>(context)
          .getTaxonomyMenu(taxonomySlug: 'product_cat');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<bannerCubit.BannerCubit, bannerState.BannerState>(
      builder: (_, state) {
        if (state is bannerState.PageLoaded && widget.banners!.isEmpty) {
          bannerLoaded = state;
          widget.banners!.addAll(state.banners);
        }

        if (bannerLoaded == null && widget.banners!.isEmpty) {
          WPRPlaceholder slidePlace = const WPRPlaceholder(
            wrapColumn: false,
            content: MySlide(content: Text('')),
          );

          return MySlider(
              slides: <Widget>[slidePlace, slidePlace, slidePlace, slidePlace]);
        }

        return MySlider(slides: loadHomeSlides(widget.banners!));
      },
      listener: (context, state) {
        if (state is bannerState.ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Colors.white, fontSize: 16.0),
              ),
            ),
          );
        }
      },
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

  _showLoader() {
    const alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: CircularProgressIndicator(
        backgroundColor: Colors.white70,
      ),
    );

    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    //Navigator.of(context, rootNavigator: true).pop();
  }
}
