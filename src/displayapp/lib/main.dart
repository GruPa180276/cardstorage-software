import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/domain/asset_files.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/domain/app_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  await AssetFiles.setProperties();
  HttpOverrides.global = MyHttpOverrides();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);r

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String title = 'Light & Dark Theme';
  // ignore: prefer_typing_uninitialized_variables
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: const BottomNavigation(),
            navigatorKey: navigatorKey,
          );
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
