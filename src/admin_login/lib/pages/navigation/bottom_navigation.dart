import 'package:flutter/material.dart';

import 'package:admin_login/pages/home/home.dart';
import 'package:admin_login/pages/stats/stats.dart';
import 'package:admin_login/pages/storage/storage.dart';
import 'package:admin_login/pages/card/cards.dart';
import 'package:admin_login/pages/user/user.dart';
import 'package:admin_login/pages/menu/menu.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final screens = [Home(), Tab1(), CardsView(), StorageView(), Tab4(), Menu()];

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
          selectedItemColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats),
              label: 'Stats',
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
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
        ));
  }
}
