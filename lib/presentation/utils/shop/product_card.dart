import 'package:flutter/material.dart';
import '../placeholder.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String name;
  final String image;
  final String price;
  final String symbol;
  final bool loading;
  final Function? onTap;
  const ProductCard({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.symbol = '€',
    this.loading = false,
    this.onTap,
  }) : super(key: key);

  get productState => this;

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
    Widget imageContainer = image.isNotEmpty
        ? Image.network(
            image,
            fit: BoxFit.fitWidth,
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

    return GestureDetector(
      child: Card(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'background_$id',
                child: Container(color: Colors.white),
              ),
              Hero(
                tag: 'img_$id',
                child: imageContainer,
              ),
              const SizedBox(height: 5),
              price.isNotEmpty
                  ? Hero(
                      tag: 'price_$id',
                      child: Column(
                        children: [
                          Material(
                            child: Text(
                              "$symbol$price",
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
                tag: 'title_$id',
                child: Material(
                  child: Text(
                    name,
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
      ),
      onTap: () {
        if (!loading && onTap != null) {
          onTap!(productState);
        }
      },
    );
  }
}
