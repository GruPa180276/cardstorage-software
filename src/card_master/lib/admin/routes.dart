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
        return MaterialPageRoute(builder: ((context) => AddCards()));
      case '/alterCards':
        if (args is String) {
          return MaterialPageRoute(
              builder: ((context) => CardSettings(cardName: args)));
        }
        return _errorRoute();

      // Storage
      case '/addStorage':
        return MaterialPageRoute(builder: ((context) => AddStorage()));
      case '/alterStorage':
        if (args is String) {
          return MaterialPageRoute(
              builder: ((context) => StorageSettings(storageName: args)));
        }
        return _errorRoute();

      //Settings
      case '/settings':
        return MaterialPageRoute(builder: ((context) => Settings()));

      //Reservations
      case '/reservations':
        return MaterialPageRoute(builder: ((context) => Reservations()));

      //Users
      case '/users':
        return MaterialPageRoute(builder: ((context) => UsersSettings()));

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
          appBar: AppBar(title: Text("Error")),
          body: Center(
            child: Text("Error"),
          ));
    });
  }
}
