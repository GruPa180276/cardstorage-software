import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'dart:async';

import 'package:app/pages/navigation/bottom_navigation.dart';
import 'package:app/pages/app_preference.dart';
import 'package:app/provider/themes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();

  runApp(const AppStart());
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
            home: const SplashScreen(),
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
        color: Colors.white,
        child:
            Image.asset("img/splashscreen.jpg", height: 200.0, width: 200.0));
  }
}
