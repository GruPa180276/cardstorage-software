import 'dart:io';
import 'package:card_master/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_master/client/domain/authentication/user_secure_storage.dart';
import 'package:card_master/client/pages/login/login_user_page.dart';
import 'package:card_master/client/pages/navigation/client_navigation.dart';
import 'package:card_master/client/provider/session_user.dart';
import 'package:card_master/client/provider/theme_provider.dart';
import 'package:card_master/client/domain/app_preferences.dart';

import 'client/provider/server_properties.dart';

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

  runApp(MyApp(
    rememberState: rememberState,
  ));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String title = 'Rfid Card Management App';
  final bool rememberState;
  const MyApp({required this.rememberState, Key? key}) : super(key: key);

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
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            routes: routes,
            home: const ClientNavigation(),
            navigatorKey: navigatorKey,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          routes: routes,
          home: const LoginUserScreen(),
          navigatorKey: navigatorKey,
        );
      },
    );
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
