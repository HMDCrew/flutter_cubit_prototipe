import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final List<Widget> pages;
  final List<IconData> pageIcons;
  const BottomNavBar(this.pages, this.pageIcons, {Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> navKey = GlobalKey();

  Color iconColor(condition) {
    return (condition ? const Color.fromARGB(255, 30, 30, 30) : Colors.white);
  }

  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> myWidgetIcons = widget.pageIcons.asMap().entries.map((entry) {
      int idx = entry.key;
      IconData icon = entry.value;
      return Icon(icon, size: 30, color: iconColor(myIndex == idx));
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: CurvedNavigationBar(
        index: myIndex,
        key: navKey,
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        items: myWidgetIcons,
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        color: const Color.fromARGB(255, 30, 30, 30),
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
      ),
      body: widget.pages[myIndex],
    );
  }
}
