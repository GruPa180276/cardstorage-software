import 'package:flutter/material.dart';
import 'package:rfidapp/pages/Login/login_page.dart';

void main() {
  runApp(new MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 1, 216, 89),
          secondary: const Color(0xFFFFC107),
        ),
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.green),
      themeMode: ThemeMode.system,
      home: new LoginScreen(
        title: 'Login Rfid',
      )));
}
