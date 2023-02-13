import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/cards/cards_page.dart';
import 'package:rfidapp/pages/reservate/reservate_page.dart';
import 'package:rfidapp/provider/size/size_extentions.dart';
import 'package:rfidapp/provider/size/size_manager.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final screens = [
    const CardPage(),
    const ReservatePage(),
  ];

  @override
  Widget build(BuildContext context) {
    SizeManager.init(MediaQuery.of(context).size);
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 1.75.fs,
          unselectedFontSize: 1.5.fs,
          type: BottomNavigationBarType.fixed,
          iconSize: 4.0.fs,
          currentIndex: currentIndex,
          onTap: (value) => setState(() => currentIndex = value),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: ColorSelect.blueAccent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Reservation',
            ),
          ],
        ));
  }
}
