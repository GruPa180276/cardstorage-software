<<<<<<< HEAD
import 'dart:io';
import 'package:card_master/client/config/properties/screen.dart';
import 'package:card_master/client/provider/size/size_manager.dart';
import 'package:card_master/client/provider/theme/rfid_themes.dart';
import 'package:card_master/routes.dart';
=======
>>>>>>> a0e40541b820fcf775b5a0b54e31ec25b22c9112
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:card_master/admin/routes.dart';
import 'package:card_master/admin/config/token_manager.dart';
import 'package:card_master/admin/provider/theme/themes.dart';
import 'package:card_master/admin/config/theme/app_preference.dart';
import 'package:card_master/admin/pages/navigation/bottom_navigation.dart';

<<<<<<< HEAD
Future main() async {
  await ServerProperties.loadEnv();
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  late bool? rememberState;
  HttpOverrides.global = MyHttpOverrides();
  rememberState = await UserSecureStorage.getRememberState() ?? false;
  if (rememberState) {
    SessionUser.fromJson(await UserSecureStorage.getUserValues(), null);
    if (!await SessionUser.reloadUserData()) {
      rememberState = false;
    }
  }
  runApp(RfidApp(
    rememberState: rememberState,
  ));
}

class RfidApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String title = 'Rfid Card Management App';
  final bool rememberState;
  const RfidApp({required this.rememberState, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        if (rememberState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            themeMode: themeProvider.getThemeMode(),
            theme: RifdAppThemes.lightTheme,
            darkTheme: RifdAppThemes.darkTheme,
            routes: routes,
            home: const ClientNavigation(),
            navigatorKey: navigatorKey,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: themeProvider.getThemeMode(),
          theme: RifdAppThemes.lightTheme,
          darkTheme: RifdAppThemes.darkTheme,
          routes: routes,
          home: const LoginUserScreen(),
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
=======
// Change app icon -> pubsec.yaml
// https://pub.dev/packages/flutter_launcher_icons
// Fix -> C:\src\flutter\.pub-cache\hosted\pub.dartlang.org\flutter_launcher_icons-0.9.3\lib\android.dart

// Change app name -> pubsec.yaml
// https://pub.dev/packages/flutter_app_name
// Replace this line -> final String minSdk = line.replaceAll(RegExp(r'[^\d]'), '');
// with this -> final String minSdk = "21"; // line.replaceAll(RegExp(r'[^\d]'), '');

// TODO
// Refactor

// Check for Typos

// Stats Page -> Design

// Formulate Error Message when deleting Storage.
// - There could be open Reservations
// - There could be cards left
// - ...

// Formulate Error Message when deleting Cards.
// - There could be open Reservations
// - ...

// Change Text of Storage Focus Verfügbar - true to something else
>>>>>>> a0e40541b820fcf775b5a0b54e31ec25b22c9112

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
  ));

  HttpOverrides.global = MyHttpOverrides();

  SecureStorage.storage.deleteAll();
  SecureStorage.setToken();

  runApp(const AppStart());
}

class AppStart extends StatelessWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'Splash Screen',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigation())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).focusColor,
        child:
            Image.asset("img/splashscreen.jpg", height: 200.0, width: 200.0));
  }
}
