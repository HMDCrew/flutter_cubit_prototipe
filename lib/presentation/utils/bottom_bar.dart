import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BottomBar extends StatelessWidget {
  final Map<String, IconData> routesIcons;
  final Widget child;
  final String? route;
  final Object? arguments;
  const BottomBar(this.route,
      {Key? key,
      this.arguments,
      required this.routesIcons,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: MyBottomNavigationBar(
        routesIcons: routesIcons,
        arguments: arguments != null ? json.encode(arguments) : '',
        route: route.toString(),
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        iconSelected: const Color.fromARGB(255, 30, 30, 30),
        bgiconSelected: Colors.white,
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final Map<String, IconData> routesIcons;
  final String route;
  final String arguments;
  final Color? iconSelected;
  final Color? bgiconSelected;
  final Color? iconUnselected;
  final Color? backgroundColor;
  final double iconSize;
  final double iconPadding;
  const MyBottomNavigationBar(
      {Key? key,
      this.iconSelected,
      this.backgroundColor,
      this.bgiconSelected,
      this.iconUnselected,
      this.iconSize = 30.0,
      this.iconPadding = 9.0,
      required this.arguments,
      required this.routesIcons,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = arguments.isNotEmpty ? jsonDecode(arguments) : {};

    return Container(
      color: backgroundColor ?? Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: routeIcons(context, args),
      ),
    );
  }

  List<Widget> routeIcons(context, Map args) {
    return routesIcons.entries.map((entry) {
      String mapRoute = entry.key;
      IconData icon = entry.value;

      return InkWell(
        onTap: () {
          // not rebuild some route
          if (mapRoute != route) {
            Navigator.of(context)
                .pushNamed(mapRoute, arguments: {'prev_route': route});
          }
        },
        child: Ink(
          width: iconSize + (iconPadding * 2),
          height: iconSize + (iconPadding * 2),
          child: route == mapRoute

              // Active icon
              ? activeIcon(icon)

              // Deactive old icon
              : args.isNotEmpty &&
                      args.containsKey('prev_route') &&
                      mapRoute == args['prev_route']
                  ? deactiveIcon(icon)

                  // normal icon
                  : normalIcon(icon),
        ),
      );
    }).toList();
  }

  Widget activeIcon(icon) => Container(
        padding: EdgeInsets.all(iconPadding),
        decoration: BoxDecoration(
          color: bgiconSelected ?? Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              color: backgroundColor?.withOpacity(0.1) ?? Colors.transparent,
              blurRadius: 10.0,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconSelected ?? const Color.fromARGB(255, 30, 30, 30),
        ),
      ).animate().move(
            duration: 250.ms,
            begin: const Offset(0, 0),
            end: const Offset(0, -15),
            curve: Curves.easeInOutQuart,
          );

  Widget deactiveIcon(icon) => Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconSelected ?? const Color.fromARGB(255, 30, 30, 30),
        ).animate().tint(
              duration: 250.ms,
              color: iconUnselected ?? Colors.white,
            ),
      ).animate().move(
            duration: 250.ms,
            begin: const Offset(0, -15),
            end: const Offset(0, 0),
            curve: Curves.easeInOutQuart,
          );

  Widget normalIcon(icon) =>
      Icon(icon, size: iconSize, color: iconUnselected ?? Colors.white);
}
