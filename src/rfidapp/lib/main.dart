import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/pages/login/login_user_page.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';
import 'package:rfidapp/provider/sessionUser.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/domain/app_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  late String? rememberState;

  HttpOverrides.global = MyHttpOverrides();
  await UserSecureStorage.getRememberState()
      .then((value) => rememberState = value ?? 'false');

  runApp(MyApp(
    rememberState: rememberState,
  ));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String title = 'Rfid Card Management App';
  // ignore: prefer_typing_uninitialized_variables
  final rememberState;
  const MyApp({this.rememberState, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        if (!(rememberState == 'true')) {
          UserSecureStorage.getUserValues()
              .then((value) => SessionUser.fromJson(value, null));

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: const BottomNavigation(),
            navigatorKey: navigatorKey,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
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
