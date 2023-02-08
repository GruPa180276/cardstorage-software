import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/favorites/favorites_page.dart';
import 'package:rfidapp/pages/cards/cards_page.dart';
import 'package:rfidapp/pages/reservate/reservate_page.dart';
import 'package:rfidapp/pages/settings/settings.dart';

class BottomNavigation extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  const BottomNavigation({Key? key, this.height = kBottomNavigationBarHeight})
      : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();

  @override
  Size get preferredSize => (Size.fromHeight(height));
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final screens = [
    const FavoritePage(),
    const CardPage(),
    const ReservatePage(),
    const SettingsPage()
  ];

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
          selectedItemColor: ColorSelect.blueAccent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoriten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Reservation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            )
          ],
        ));
  }
}
