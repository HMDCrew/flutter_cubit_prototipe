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

  Widget get placeholder => const WPRPlaceholder(
        wrapColumn: false,
        content: DecoratedBox(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
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
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'img_$id',
              transitionOnUserGestures: true,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                return Stack(children: [
                  Positioned.fill(
                    child: FadeTransition(
                        opacity: animation, child: fromHeroContext.widget),
                  ),
                  Positioned.fill(
                      child: FadeTransition(
                          opacity: ReverseAnimation(
                              ModalRoute.of(context)?.secondaryAnimation ??
                                  animation),
                          child: toHeroContext.widget)),
                ]);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Material(child: imageContainer),
              ),
            ),
            const SizedBox(height: 5),
            price.isNotEmpty
                ? Hero(
                    tag: 'price_$id',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "$symbol$price",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 30, 30, 30),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 0),
            Hero(
              tag: 'title_$id',
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  right: 10,
                  left: 10,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 80, 80, 80),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
