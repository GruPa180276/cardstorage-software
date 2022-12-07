import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/authentication/authentication.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/pop_up/email_popup.dart';

import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';

import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/user.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({Key? key}) : super(key: key);
  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  bool rememberValue = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  // ignore: must_cal_super
  void initState() {
    init();
  }

  Future init() async {
    final rememberState = await UserSecureStorage.getRememberState() ?? '';

    if (rememberState == "true") {
      final email = await UserSecureStorage.getUsername() ?? '';
      final password = await UserSecureStorage.getPassword() ?? '';
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        if (rememberState == "true") {
          rememberValue = true;
        }
      });
    } else {
      AadAuthentication.oauth.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildGreeting(this.context),
              Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: buttonField(
                    bgColor: ColorSelect.blueAccent,
                    borderColor: ColorSelect.blueAccent,
                    text: 'SIGN IN via Micrsoft',
                    textColor: Colors.white,
                    onPress: () {
                      print(
                          new DateTime.now().microsecondsSinceEpoch / 1000000);

                      sigIn();
                    },
                  )),
              buildRememberMe(this.context),
              const SizedBox(
                height: 50,
              ),
              buildProblemsText(context),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGreeting(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
          child: const Text('Guten',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
          child: const Text('Tag',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(160.0, 200.0, 0.0, 0.0),
          child: Text('.',
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato",
                  color: Theme.of(context).secondaryHeaderColor)),
        )
      ],
    );
  }

  Widget buildRememberMe(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 0),
      child: CheckboxListTile(
        visualDensity: VisualDensity.compact,
        activeColor: Theme.of(context).secondaryHeaderColor,
        title: const Text("Remember me"),
        //contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
        value: rememberValue,

        onChanged: (newValue) {
          setState(() {
            rememberValue = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget buildProblemsText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Probleme?',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        const SizedBox(width: 5.0),
        InkWell(
          onTap: () async {
            EmailPopUp.show(
                this.context, "grubauer.patrick@gmail.com", "Test", "Test");
          },
          child: Text(
            'Stelle Sie eine Frage.',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  void sigIn() async {
    try {
      UserSecureStorage.setRememberState(rememberValue.toString());

      await AadAuthentication.oauth.login();

      String? accessToken = await AadAuthentication.oauth.getAccessToken();
      bool registered = false;
      if (accessToken != null &&
          registered) //api get// see if user is registered
      {
        var userResponse = await Data.getUserData(accessToken);
        User.setUserValues(jsonDecode(userResponse!.body));
        UserSecureStorage.setRememberState(rememberValue.toString());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomNavigation()),
            (Route<dynamic> route) => false);
      } else if (accessToken != null && registered == false) {
        //mqtt Timer
        await MqttTimer.startTimer(context, "to-sign-up");
        if (MqttTimer.getSuccessful()) {
          CoolAlert.show(
            backgroundColor: Colors.transparent,
            confirmBtnColor: ColorSelect.blueAccent,
            borderRadius: 50,
            context: context,
            type: CoolAlertType.success,
            text: 'Registrierung erfolgreich',
            
          );
        }
      } else {
        UserSecureStorage.setRememberState("false");

        setState(() {
          rememberValue = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}