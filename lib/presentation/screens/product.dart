import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../logic/cubit/product_cubit.dart';
import '../utils/placeholder.dart';
import '../utils/shop/product_card.dart';
import '../utils/slide.dart';
import '../utils/slider.dart';

class Product extends StatefulWidget {
  final ProductCard product;
  const Product({Key? key, required this.product}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late final WebViewController controller;
  double webViewheight = 250.0;

  @override
  Widget build(BuildContext context) {
    Widget placeholder = const WPRPlaceholder(
      wrapColumn: false,
      content: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );

    Widget imageContainer = widget.product.image.isNotEmpty
        ? Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 20.0, left: 20.0, top: 15.0),
              child: Image.network(
                widget.product.image,
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
              ),
            ),
          )
        : placeholder;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'img_${widget.product.id}',
                transitionOnUserGestures: true,
                flightShuttleBuilder: (flightContext, animation,
                    flightDirection, fromHeroContext, toHeroContext) {
                  return Stack(children: [
                    Positioned.fill(child: fromHeroContext.widget),
                    Positioned.fill(child: toHeroContext.widget),
                  ]);
                },
                child: Material(
                  child: FadeTransition(
                    opacity: ModalRoute.of(context)?.animation ??
                        const AlwaysStoppedAnimation(0.5),
                    child: FadeTransition(
                      opacity: ReverseAnimation(
                        ModalRoute.of(context)?.secondaryAnimation ??
                            const AlwaysStoppedAnimation(0.5),
                      ),
                      child: BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoaded) {
                            return Container(
                              color: Colors.white,
                              child: MySlider(
                                  isColumn: false,
                                  slides: productGallery(
                                      state.product['gallery_image_ids']),
                                  dotsEffect: const ExpandingDotsEffect(
                                      activeDotColor: Colors.black)),
                            );
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: imageContainer,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              widget.product.price.isNotEmpty
                  ? Hero(
                      tag: 'price_${widget.product.id}',
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              "${widget.product.symbol}${widget.product.price}",
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
                  : const SizedBox(height: 0),
              Hero(
                tag: 'title_${widget.product.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 80, 80, 80),
                    ),
                  ),
                ),
              ),
              BlocBuilder<ProductCubit, ProductState>(
                  builder: (productContext, state) {
                if (state is ProductLoaded) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: webViewheight,
                    child: state.product['description'].isNotEmpty
                        ? WebViewWidget(
                            controller: WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..setNavigationDelegate(
                                NavigationDelegate(),
                              )
                              ..loadHtmlString(state.product['description'] +
                                  '''<script> const resizeObserver = new ResizeObserver(entries => Resize.postMessage("height" + (entries[0].target.clientHeight).toString()) ) resizeObserver.observe(document.body) </script>''')
                              ..addJavaScriptChannel("Resize",
                                  onMessageReceived:
                                      (JavaScriptMessage message) {
                                        print(message);
                                updateHeight();
                              }))
                        : const SizedBox(height: 0),
/*
JavascriptChannel(name: "Resize", onMessageReceived: (JavascriptMessage message) {
  updateHeight();
})

*/
                  );
                }

                return const CircularProgressIndicator();
              }),
            ],
          ),
        ),
      ),
    );
  }

  List<MySlide> productGallery(List gallery) {
    List<MySlide> slides = <MySlide>[];

    slides.add(
      MySlide(
        bgColor: Colors.white,
        content: Container(),
        backgroundImage: widget.product.image,
      ),
    );

    for (String slide in gallery) {
      slides.add(
        MySlide(
          bgColor: Colors.white,
          content: Container(),
          backgroundImage: slide,
        ),
      );
    }

    return slides;
  }

  void updateHeight() async {
    final pageHeight = await controller.runJavaScriptReturningResult("document.documentElement.scrollHeight;");
    double height = double.parse(pageHeight.toString());

    print(pageHeight);

    if (webViewheight != height) {
      setState(() {
        webViewheight = height;
      });
    }
  }
}
