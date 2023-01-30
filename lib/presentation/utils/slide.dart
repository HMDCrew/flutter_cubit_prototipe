import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MySlide extends StatelessWidget {
  final dynamic content;
  final String? backgroundImage;
  final Color? bgColor;

  const MySlide(
      {Key? key, required this.content, this.backgroundImage, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: bgColor ?? Colors.grey[500],
        image: DecorationImage(
          fit: BoxFit.contain,
          image: backgroundImage != null
              ? NetworkImage(backgroundImage!)
              : MemoryImage(kTransparentImage) as ImageProvider,
        ),
      ),
      child: content,
    );
  }
}
