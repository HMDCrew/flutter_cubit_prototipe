import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/banners_cubit.dart';
import '../../logic/cubit/shop_cubit.dart';
import '../screens/home.dart';
import '../screens/cart.dart';
import '../screens/favorites.dart';
import '../screens/profile.dart';
import '../screens/shop.dart';
import '../utils/bottom_bar.dart';

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
              page: 0,
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
            BlocProvider.of<ShopCubit>(context).getProducts(page: 0);

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
