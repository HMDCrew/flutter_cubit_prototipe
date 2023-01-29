import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_skeleton_routed/presentation/screens/product.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../logic/cubit/shop_cubit.dart';
import '../utils/shop/product_card.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  ScrollController scrollController = ScrollController();

  // placeholders
  List<Widget> placeShop = prodPlaceholder();

  static List<Widget> prodPlaceholder() {
    ProductCard productPlace = const ProductCard(
        id: 0, image: '', price: '', name: 'Loading...', loading: true);
    return <Widget>[productPlace, productPlace, productPlace, productPlace];
  }

  @override
  void initState() {
    super.initState();
    onScrollListener();
  }

  void onScrollListener() {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        BlocProvider.of<ShopCubit>(context).loadMoreProducts();
        print('end page');
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
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (_, state) {
        // Loaded
        if (state is ShopLoaded) {
          return buildProductsList(state.products);
        }

        // No products found
        if (state is ErrorShop) {
          return buildProductsList(
              BlocProvider.of<ShopCubit>(context).shopProducts);
        }

        // Loading
        return buildProductsList([]);
      },
    );
  }

  Widget buildProductsList(List prods) => Container(
        margin: const EdgeInsets.all(16),
        child: MasonryGridView.count(
          physics: const BouncingScrollPhysics(),
          controller: prods.isNotEmpty ? scrollController : null,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
          crossAxisCount: 2,
          itemCount: prods.isEmpty ? placeShop.length : prods.length,
          itemBuilder: (context, index) {
            return prods.isEmpty
                ? placeShop[index]
                : ProductCard(
                    id: prods[index]['id'],
                    name: prods[index]['name'],
                    image: prods[index]['image_uri'],
                    price: prods[index]['price'],
                    symbol: prods[index]['symbol'],
                    onTap: (ProductCard prod) {
                      Navigator.of(context).pushNamed('/product', arguments: prod);
                    },
                  );
          },
        ),
      );
}
