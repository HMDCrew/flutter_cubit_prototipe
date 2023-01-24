import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../placeholder.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String name;
  final String? image;
  final String? price;
  final String symbol;
  final bool loading;
  const ProductCard(
      {Key? key,
      required this.id,
      required this.name,
      this.image,
      this.price,
      this.symbol = '€',
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageContainer = loading
        ? WPRPlaceholder(
            wrapColumn: false,
            content: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: const Color.fromARGB(255, 0, 0, 0))),
          )
        : image != null
            ? Image.network(image!)
            : Image.memory(kTransparentImage);

    return ElevatedButton(
      onPressed: () {
        if (!loading) {
          print(id);
          print(name);
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
                ? Text("$symbol$price",
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 30, 30, 30),
                        fontWeight: FontWeight.bold))
                : const Text(''),
            const SizedBox(height: 5),
            Text(name,
                style: const TextStyle(
                    fontSize: 10, color: Color.fromARGB(255, 80, 80, 80)))
          ],
        ),
      ),
    );
  }
}
