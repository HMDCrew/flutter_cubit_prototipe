import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../states_management/products/product_cubit.dart' as prodCubit;
import '../../../states_management/products/product_states.dart' as prodStates;

class Products extends StatefulWidget {
  final List? products = [];
  Products({Key? key, List? products}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  prodStates.PageLoaded? productsLoaded;

  @override
  void initState() {
    if (widget.products!.isEmpty) {
      BlocProvider.of<prodCubit.ProductCubit>(context).getProducts(page: 0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<prodCubit.ProductCubit, prodStates.ProductState>(
      builder: (_, state) {
        if (state is prodStates.PageLoaded && widget.products!.isEmpty) {
          productsLoaded = state;
          widget.products!.addAll(state.products);
        }

        if (productsLoaded == null && widget.products!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return const Center(
          child: Text(
            'loaded',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
      listener: (context, state) {
        if (state is prodStates.ErrorState) {
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

  // List<MySlide> loadHomeSlides(banners) {
  //   List<MySlide> slides = <MySlide>[];

  //   for (final slide in banners) {
  //     if (slide['include_metas']['banner_text'] != '') {
  //       if (slide['image'] != false) {
  //         slides.add(MySlide(
  //             content: HomeSlide(slide: slide),
  //             backgroundImage: slide['image']));
  //       } else {
  //         slides.add(MySlide(content: HomeSlide(slide: slide)));
  //       }
  //     }
  //   }
  //   return slides;
  // }

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
    // Navigator.of(context, rootNavigator: true).pop();
  }
}
