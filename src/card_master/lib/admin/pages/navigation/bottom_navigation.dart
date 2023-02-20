import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/log/logs.dart';
import 'package:card_master/admin/pages/card/cards.dart';
import 'package:card_master/admin/pages/status/status.dart';
import 'package:card_master/admin/pages/storage/storage.dart';
import 'package:card_master/admin/pages/navigation/websockets.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Websockets.setupWebSockets();
    Websockets.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> screens = [
      StatusView(),
      CardsView(),
      StorageView(),
      Logs(),
    ];

    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (value) => setState(() => currentIndex = value),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          items: const [
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
