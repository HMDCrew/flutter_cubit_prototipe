import 'package:flutter/material.dart';

import '../utils/placeholder.dart';
import '../utils/shop/product_card.dart';

class Product extends StatelessWidget {
  final ProductCard product;
  const Product({Key? key, required this.product}) : super(key: key);

  Widget get placeholder => WPRPlaceholder(
        wrapColumn: false,
        content: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget imageContainer = product.image.isNotEmpty
        ? Image.network(
            product.image,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame == null) return placeholder;

              return child;
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return placeholder;
            },
          )
        : placeholder;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'background_${product.id}',
              child: Container(color: Colors.white),
            ),
            Hero(
              tag: 'img_${product.id}',
              child: imageContainer,
            ),
            const SizedBox(height: 5),
            product.price.isNotEmpty
                ? Hero(
                    tag: 'price_${product.id}',
                    child: Column(
                      children: [
                        Material(
                          child: Text(
                            "${product.symbol}${product.price}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 30, 30, 30),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )
                : const Text(''),
            Hero(
              tag: 'title_${product.id}',
              child: Material(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(255, 80, 80, 80),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
