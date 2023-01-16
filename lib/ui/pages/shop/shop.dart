import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../states_management/products/product_cubit.dart' as prodCubit;
import '../../../states_management/products/product_states.dart' as prodStates;
import '../../utils/inc/product_card.dart';

class Shop extends StatefulWidget {
  final List? products = [];
  Shop({Key? key, List? products}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
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
          ProductCard productPlace = const ProductCard(
              id: 0, name: 'Loading...', loading: true);
          final List<Widget> placeShop = <Widget>[
            productPlace,
            productPlace,
            productPlace,
            productPlace
          ];

          return Container(
            margin: const EdgeInsets.all(16),
            child: MasonryGridView.count(
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                crossAxisCount: 2,
                itemCount: placeShop.length,
                itemBuilder: (context, index) {
                  return placeShop[index];
                }),
          );
        }

        return Container(
          margin: const EdgeInsets.all(16),
          child: MasonryGridView.count(
            mainAxisSpacing: 11,
            crossAxisSpacing: 11,
            crossAxisCount: 2,
            itemCount: widget.products!.length,
            itemBuilder: (context, index) {
              return ProductCard(
                id: widget.products![index]['id'],
                name: widget.products![index]['name'],
                image: widget.products![index]['image_uri'],
                price: widget.products![index]['price'],
                symbol: widget.products![index]['symbol'],
              );
            },
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
