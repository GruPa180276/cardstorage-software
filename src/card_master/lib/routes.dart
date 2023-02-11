import 'package:card_master/client/pages/account/account_page.dart';
import 'package:card_master/client/pages/cards/cards_page.dart';
import 'package:card_master/client/pages/favorites/favorites_page.dart';
import 'package:card_master/client/pages/login/login_user_page.dart';
import 'package:card_master/client/pages/navigation/client_navigation.dart';
import 'package:card_master/client/pages/reservate/reservate_page.dart';
import 'package:card_master/client/pages/settings/settings.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  "/login": (context) => const LoginUserScreen(),
  "/favoritepage": (context) => const FavoritePage(),
  "/cardpage": (context) => const CardPage(),
  "/reservatepage": (context) => const ReservatePage(),
  "/settingspage": (context) => const SettingsPage(),
  "/accountpage": (context) => const AccountPage(),
  "/clientnavigation": (context) => const ClientNavigation(),
};
