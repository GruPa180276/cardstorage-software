import 'package:flutter/material.dart';

import 'package:admin_login/pages/card/add_cards.dart';
import 'package:admin_login/pages/card/alter_cards.dart';
import 'package:admin_login/pages/card/remove_cards.dart';

import 'package:admin_login/pages/storage/add_storage.dart';
import 'package:admin_login/pages/storage/alter_storage.dart';
import 'package:admin_login/pages/storage/remove_storage.dart';

import 'package:admin_login/pages/user/add_user.dart';
import 'package:admin_login/pages/user/alter_user.dart';
import 'package:admin_login/pages/user/remove_user.dart';

import 'package:admin_login/pages/stats/tab1_stats.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Cards
      case '/addCards':
        return MaterialPageRoute(builder: ((context) => AddCards()));
      case '/alterCards':
        if (args is int) {
          return MaterialPageRoute(builder: ((context) => CardSettings(args)));
        }
        return _errorRoute();
      case '/removeCards':
        return MaterialPageRoute(builder: ((context) => RemoveCards()));

      // Storage
      case '/addStorage':
        return MaterialPageRoute(builder: ((context) => AddStorage()));
      case '/alterStorage':
        if (args is int) {
          return MaterialPageRoute(
              builder: ((context) => StorageSettings(args)));
        }
        return _errorRoute();
      case '/removeStorage':
        return MaterialPageRoute(builder: ((context) => RemoveStorage()));

      // User
      case '/addUser':
        return MaterialPageRoute(builder: ((context) => AddUser()));
      case '/alterUser':
        if (args is int) {
          return MaterialPageRoute(builder: ((context) => UserSettings(args)));
        }
        return _errorRoute();
      case '/removeUser':
        return MaterialPageRoute(builder: ((context) => RemoveUsers()));

      //Stats
      case '/stats':
        return MaterialPageRoute(builder: ((context) => CardStats()));

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
