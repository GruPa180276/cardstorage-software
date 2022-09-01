import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/pages/login/utils/app_preference.dart';
import 'package:rfidapp/pages/login/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  await UserSecureStorage.setRememberState('true');
  final rememberState = await UserSecureStorage.getRememberState() ?? 'false';

  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp(
    rememberState: rememberState,
  ));
}

class MyApp extends StatelessWidget {
  static const String title = 'Light & Dark Theme';
  final rememberState;
  const MyApp({this.rememberState, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        if (rememberState == 'true') {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: const BottomNavigation(),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
