import 'package:flutter/material.dart';

import 'package:admin_login/pages/logs/logs.dart';
import 'package:admin_login/pages/card/cards.dart';
import 'package:admin_login/pages/storage/storage.dart';
import 'package:admin_login/pages/status/status.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  // StatsView()
  final screens = [StatusView(), CardsView(), StorageView(), Logs()];

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
            /*
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats),
              label: 'Statistik',
            ),
            */
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Karten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'Storage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Logs',
            ),
          ],
        ));
  }
}
