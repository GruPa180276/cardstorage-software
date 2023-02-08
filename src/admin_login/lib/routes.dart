import 'package:flutter/material.dart';

import 'package:admin_login/pages/user/users.dart';
import 'package:admin_login/pages/card/add_cards.dart';
import 'package:admin_login/pages/card/alter_cards.dart';
import 'package:admin_login/pages/card/remove_cards.dart';

import 'package:admin_login/pages/storage/add_storage.dart';
import 'package:admin_login/pages/storage/alter_storage.dart';
import 'package:admin_login/pages/storage/remove_storage.dart';

import 'package:admin_login/pages/reservation/reservations.dart';

import 'package:admin_login/pages/status/status_storage.dart';

import 'package:admin_login/pages/appbar/settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Cards
      case '/addCards':
        return MaterialPageRoute(builder: ((context) => AddCards()));
      case '/alterCards':
        if (args is String) {
          return MaterialPageRoute(builder: ((context) => CardSettings(args)));
        }
        return _errorRoute();
      case '/removeCards':
        return MaterialPageRoute(builder: ((context) => RemoveCards()));

      // Storage
      case '/addStorage':
        return MaterialPageRoute(builder: ((context) => AddStorage()));
      case '/alterStorage':
        if (args is String) {
          return MaterialPageRoute(
              builder: ((context) => StorageSettings(storage: args)));
        }
        return _errorRoute();
      case '/removeStorage':
        return MaterialPageRoute(builder: ((context) => RemoveStorage()));

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
