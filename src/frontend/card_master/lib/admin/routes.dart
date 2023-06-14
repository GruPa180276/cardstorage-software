import 'package:card_master/client/pages/login/login_user_page.dart';
import 'package:card_master/client/pages/navigation/client_navigation.dart';
import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/user/users.dart';
import 'package:card_master/admin/pages/card/add_cards.dart';
import 'package:card_master/admin/pages/card/alter_cards.dart';

import 'package:card_master/admin/pages/storage/add_storage.dart';
import 'package:card_master/admin/pages/storage/alter_storage.dart';

import 'package:card_master/admin/pages/reservation/reservations.dart';

import 'package:card_master/admin/pages/status/status_storage.dart';

import 'package:card_master/admin/pages/appbar/settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Cards
      case '/addCards':
        return MaterialPageRoute(builder: ((context) => const AddCards()));
      case '/alterCards':
        if (args is String) {
          return MaterialPageRoute(
              builder: ((context) => CardSettings(cardName: args)));
        }
        return _errorRoute();

      // Storage
      case '/addStorage':
        return MaterialPageRoute(builder: ((context) => const AddStorage()));
      case '/alterStorage':
        if (args is String) {
          return MaterialPageRoute(
              builder: ((context) => StorageSettings(storageName: args)));
        }
        return _errorRoute();

      //Settings
      case '/settings':
        return MaterialPageRoute(builder: ((context) => const Settings()));

      //Reservations
      case '/reservations':
        return MaterialPageRoute(builder: ((context) => const Reservations()));

      //Users
      case '/users':
        return MaterialPageRoute(builder: ((context) => const UsersSettings()));

      //Client-View
      case '/client':
        return MaterialPageRoute(
            builder: ((context) => const ClientNavigation()));

      //Log-Out
      case '/logout':
        return MaterialPageRoute(
            builder: ((context) => const LoginUserScreen()));

      //Status
      case '/status':
        if (args is String) {
          return MaterialPageRoute(
              builder: ((context) => StatusStorage(name: args)));
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(title: const Text("Error")),
          body: const Center(
            child: Text("Error"),
          ));
    });
  }
}
