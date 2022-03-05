
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'mainPages/add.dart';
import 'mainPages/cost.dart';
import 'mainPages/home.dart';


class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int selectedIndex = 0;
  final pages = [const HomePage(), const AddPage(), const FixedCost()];
  final items = <Widget>[
    const Icon(Icons.home_rounded),
    const Icon(Icons.add_rounded),
    const Icon(Icons.attach_money_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.grey[50]!,
        buttonBackgroundColor: Colors.grey[50]!,
        backgroundColor: Colors.orangeAccent[100]!,
        animationDuration: const Duration(milliseconds: 200),
        height: 75,
        items: items,
        index: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
