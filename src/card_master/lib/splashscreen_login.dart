import 'package:flutter/material.dart';

import 'dart:async';
import 'package:card_master/client/pages/login/login_user_page.dart';

class SplashScreenLogin extends StatefulWidget {
  const SplashScreenLogin({Key? key}) : super(key: key);

  @override
  State<SplashScreenLogin> createState() => _SplashScreenLoginState();
}

class _SplashScreenLoginState extends State<SplashScreenLogin> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginUserScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).focusColor,
        child:
            Image.asset("img/splashscreen.jpg", height: 200.0, width: 200.0));
  }
}
