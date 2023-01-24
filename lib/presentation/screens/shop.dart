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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (_, state) {
        if (state is ShopLoaded) {
          return Container(
            margin: const EdgeInsets.all(16),
            child: MasonryGridView.count(
              mainAxisSpacing: 11,
              crossAxisSpacing: 11,
              crossAxisCount: 2,
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  id: state.products[index]['id'],
                  name: state.products[index]['name'],
                  image: state.products[index]['image_uri'],
                  price: state.products[index]['price'],
                  symbol: state.products[index]['symbol'],
                );
              },
            ),
          );
        }

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
