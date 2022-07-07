import 'package:flutter/material.dart';
import 'package:loginv1/Login/login_page.dart';

void main() {
  runApp(const MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 1, 216, 89),
          secondary: const Color(0xFFFFC107),
        ),
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
      themeMode: ThemeMode.system,
      home: LoginScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
