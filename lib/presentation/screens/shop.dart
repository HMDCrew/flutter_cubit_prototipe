import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../logic/cubit/shop_cubit.dart';
import '../utils/shop/product_card.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List products = [];
  int currentPage = 0;
  bool nextPageAccess = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    onScrollListener();
  }

  void onScrollListener() {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (nextPageAccess) {
          currentPage = currentPage + 1;
          BlocProvider.of<ShopCubit>(context)
              .getProducts(page: currentPage + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        //print(state);
      },
      buildWhen: (previous, current) {
        //print(previous is ShopLoaded);

        if (current is ErrorShop) {
          nextPageAccess = false;
        }

        return current is! ErrorShop && nextPageAccess;
      },
      builder: (_, state) {
        //print('test');
        // Loaded
        if (state is ShopLoaded) {
          products.addAll(state.products);
          // if( products != state.products ){
          //   print('diff');
          // }
          // state.update(products);
          return Container(
            margin: const EdgeInsets.all(16),
            child: MasonryGridView.count(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              mainAxisSpacing: 11,
              crossAxisSpacing: 11,
              crossAxisCount: 2,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  id: products[index]['id'],
                  name: products[index]['name'],
                  image: products[index]['image_uri'],
                  price: products[index]['price'],
                  symbol: products[index]['symbol'],
                  onTap: (ProductCard prod) {
                    print(prod.id);
                    print(prod.name);
                  },
                );
              },
            ),
          );
        }

        // Loading
        ProductCard productPlace =
            const ProductCard(id: 0, name: 'Loading...', loading: true);
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
            },
          ),
        );
      },
    );
  }
}
