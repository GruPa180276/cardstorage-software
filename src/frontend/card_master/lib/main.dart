import 'package:flutter/material.dart';

import 'dart:io';
import 'package:provider/provider.dart';
import 'package:card_master/routes.dart';
import 'package:card_master/splashscreen.dart';
import 'package:card_master/admin/routes.dart';
import 'package:card_master/splashscreen_login.dart';
import 'package:card_master/client/provider/theme/rfid_themes.dart';
import 'package:card_master/client/provider/theme/theme_provider.dart';
import 'package:card_master/client/domain/persistent/app_preferences.dart';
import 'package:card_master/client/config/properties/server_properties.dart';
import 'package:card_master/client/domain/persistent/user_secure_storage.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';

Future main() async {
  await ServerProperties.loadEnv();

  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  late bool? rememberState;
  HttpOverrides.global = MyHttpOverrides();
  rememberState = await UserSecureStorage.getRememberState() ?? false;
  if (rememberState) {
    UserSessionManager.fromJson(await UserSecureStorage.getUserValues(), null);
    if (!await UserSessionManager.reloadUserData()) {
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
            themeMode: themeProvider.getThemeMode(),
            theme: RifdAppThemes.lightTheme,
            darkTheme: RifdAppThemes.darkTheme,
            routes: routes,
            home: const SplashScreen(),
            navigatorKey: navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: themeProvider.getThemeMode(),
          theme: RifdAppThemes.lightTheme,
          darkTheme: RifdAppThemes.darkTheme,
          routes: routes,
          home: const SplashScreenLogin(),
          navigatorKey: navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
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
