import 'dart:io';

import 'package:card_master/admin/config/token_manager.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';
import 'package:card_master/client/provider/theme/rfid_themes.dart';
import 'package:card_master/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_master/client/domain/persistent/user_secure_storage.dart';
import 'package:card_master/client/pages/login/login_user_page.dart';
import 'package:card_master/client/pages/navigation/client_navigation.dart';
import 'package:card_master/client/provider/theme/theme_provider.dart';
import 'package:card_master/client/domain/persistent/app_preferences.dart';
import 'client/config/properties/server_properties.dart';

Future main() async {
  await ServerProperties.loadEnv();

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  late bool? rememberState;
  HttpOverrides.global = MyHttpOverrides();
  rememberState = await UserSecureStorage.getRememberState() ?? false;
  if (rememberState) {
    if (!await UserSessionManager.reloadUserData()) {
      rememberState = false;
    } else {
      UserSessionManager.fromJson(
          await UserSecureStorage.getUserValues(), null);
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
    SecureStorage.storage.deleteAll();
    SecureStorage.setToken(context);

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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
