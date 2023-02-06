import 'dart:io';

import 'package:admin_login/config/token_manager.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:admin_login/routes.dart';
import 'package:admin_login/provider/theme/themes.dart';
import 'package:admin_login/config/theme/app_preference.dart';
import 'package:admin_login/pages/navigation/bottom_navigation.dart';

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

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
  ));

  HttpOverrides.global = MyHttpOverrides();

  SecureStorage.storage.deleteAll();
  SecureStorage.setToken();

  runApp(AppStart());
}

// Change app icon -> pubsec.yaml
// https://pub.dev/packages/flutter_launcher_icons
// Fix -> C:\src\flutter\.pub-cache\hosted\pub.dartlang.org\flutter_launcher_icons-0.9.3\lib\android.dart

// Change app name -> pubsec.yaml
// https://pub.dev/packages/flutter_app_name
// Replace this line -> final String minSdk = line.replaceAll(RegExp(r'[^\d]'), '');
// with this -> final String minSdk = "21"; // line.replaceAll(RegExp(r'[^\d]'), '');

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
            home: SplashScreen(),
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
        Duration(seconds: 3),
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
