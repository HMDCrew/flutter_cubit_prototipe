import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_skeleton_routed/presentation/screens/product.dart';

import '../../logic/cubit/banners_cubit.dart';
import '../../logic/cubit/product_cubit.dart';
import '../../logic/cubit/shop_cubit.dart';
import '../screens/home.dart';
import '../screens/cart.dart';
import '../screens/favorites.dart';
import '../screens/profile.dart';
import '../screens/shop.dart';
import '../utils/bottom_bar.dart';
import '../utils/shop/product_card.dart';

class CustomPageRoute<T> extends PageRoute<T> {
  final RoutePageBuilder pageBuilder;

  CustomPageRoute({required this.pageBuilder});
  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: pageBuilder(context, animation, secondaryAnimation),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}

class AppRouter {
  Map<String, IconData> routeIcons = {
    '/': Icons.home,
    '/favorites': Icons.favorite,
    '/shop': Icons.local_mall,
    '/cart': Icons.shopping_cart,
    '/profile': Icons.person,
  };

  // BottomBar => next steps: convert this widget with Cubit
  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            // ask api resources
            BlocProvider.of<BannersCubit>(context).getBanners(
              page: 1,
              includeMetas: 'banner_text, color_title, click_through_url',
            );

            return BottomBar(
              routeSettings.name,
              arguments: routeSettings.arguments,
              routesIcons: routeIcons,
              child: const Home(),
            );
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case '/favorites':
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => BottomBar(
            routeSettings.name,
            arguments: routeSettings.arguments,
            routesIcons: routeIcons,
            child: const Favorites(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case '/shop':
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            // ask api resources
            BlocProvider.of<ShopCubit>(context).onInit(page: 1);

            return BottomBar(
              routeSettings.name,
              arguments: routeSettings.arguments,
              routesIcons: routeIcons,
              child: const Shop(),
            );
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case '/product':
        Map<String, dynamic> args =
            routeSettings.arguments as Map<String, dynamic>;

        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            // ask api product informations
            BlocProvider.of<ProductCubit>(context)
                .getProduct(args['prod'].id.toString());

            return Product(product: args['prod'] as ProductCard);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 1000),
        );

      case '/cart':
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => BottomBar(
            routeSettings.name,
            arguments: routeSettings.arguments,
            routesIcons: routeIcons,
            child: const Cart(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      case '/profile':
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => BottomBar(
            routeSettings.name,
            arguments: routeSettings.arguments,
            routesIcons: routeIcons,
            child: const Profile(),
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
    }
  }
}
