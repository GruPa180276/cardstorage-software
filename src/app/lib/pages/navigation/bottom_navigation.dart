import 'package:flutter/material.dart';

import 'package:app/pages/home.dart';
import 'package:app/pages/home/tab1.dart';
import 'package:app/pages/storage/tab2.dart';
import 'package:app/pages/card/tab3.dart';
import 'package:app/pages/menu.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final screens = [Home(), Tab1(), Tab2(), Tab3(), Menu()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (value) => setState(() => currentIndex = value),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Colors.blueGrey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'Storages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'More',
            )
          ],
        ));
  }
}
