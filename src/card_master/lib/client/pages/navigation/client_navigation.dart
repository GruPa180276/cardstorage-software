import 'package:card_master/client/config/properties/screen.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:card_master/client/provider/size/size_manager.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/pages/favorites/favorites_page.dart';
import 'package:card_master/client/pages/cards/cards_page.dart';
import 'package:card_master/client/pages/reservate/reservate_page.dart';
import 'package:card_master/client/pages/settings/settings.dart';

class ClientNavigation extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  const ClientNavigation({Key? key, this.height = kBottomNavigationBarHeight})
      : super(key: key);

  @override
  State<ClientNavigation> createState() => _ClientNavigationState();

  @override
  Size get preferredSize => (Size.fromHeight(height));
}

class _ClientNavigationState extends State<ClientNavigation> {
  int currentIndex = 0;
  final screens = [
    const FavoritePage(),
    const CardPage(),
    const ReservatePage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    SizeManager().init(
        MediaQuery.of(context).size, Screen.getScreenOrientation(context));
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 5.0.fs,
          unselectedFontSize: 1.3.fs,
          selectedFontSize: 1.9.fs,
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
              label: 'Karten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Reservierung',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Eintellungen',
            )
          ],
        ));
  }
}
