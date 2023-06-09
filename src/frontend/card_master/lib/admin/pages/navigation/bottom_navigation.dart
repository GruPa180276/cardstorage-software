import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:card_master/admin/pages/log/logs.dart';
import 'package:card_master/admin/pages/card/cards.dart';
import 'package:card_master/admin/pages/status/status.dart';
import 'package:card_master/admin/pages/storage/storage.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> screens = [
      const StatusView(),
      const CardsView(),
      const StorageView(),
      const Logs(),
    ];

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
            body: screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 20.sp,
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
      },
    );
  }
}
