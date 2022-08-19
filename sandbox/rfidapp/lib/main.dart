import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfidapp/provider/theme_provider.dart';
import 'package:rfidapp/pages/Login/login_page.dart';
import 'package:rfidapp/pages/Login/Utils/app_preference.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();

  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Light & Dark Theme';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: title,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: const LoginScreen(),
          );
        },
      );
}




// import 'package:flutter/material.dart';
// import 'package:rfidapp/pages/Login/login_page.dart';
// import 'package:rfidapp/provider/theme_provider.dart';

// void main() {
//   runApp(MaterialApp(

//       // darkTheme:
//       //     ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
//       themeMode: ThemeMode.system,
//       theme: MyThemes.lightTheme,
//       darkTheme: MyThemes.darkTheme,
//       home: const LoginScreen()));
// }
