import 'package:flutter/material.dart';
import '../placeholder.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String name;
  final String? image;
  final String? price;
  final String symbol;
  final bool loading;
  final Function? onTap;
  const ProductCard({
    Key? key,
    required this.id,
    required this.name,
    this.image,
    this.price,
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
    Widget imageContainer = loading
        ? placeholder
        : image!.isNotEmpty
            ? Image.network(
                image!,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (frame == null) {
                    return placeholder;
                  }
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return placeholder;
                },
              )
            : placeholder;

    return ElevatedButton(
      onPressed: () {
        if (!loading && onTap != null) {
          onTap!(productState);
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageContainer,
            const SizedBox(height: 5),
            price != null && price!.isNotEmpty
                ? Text(
                    "$symbol$price",
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 30, 30, 30),
                        fontWeight: FontWeight.bold),
                  )
                : const Text(''),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
            )
          ],
        ),
      ),
    );
  }
}
