// ignore_for_file: use_build_context_synchronously
import 'dart:ffi';

import 'package:card_master/client/config/properties/screen.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/response_snackbar.dart';
import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:card_master/client/provider/size/size_manager.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/domain/types/login_status_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/email_popup.dart';
import 'package:card_master/client/pages/widgets/widget/default_custom_button.dart';
import 'package:card_master/client/pages/navigation/client_navigation.dart';
import 'package:card_master/client/domain/authentication/session_user.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({Key? key}) : super(key: key);
  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  bool rememberValue = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager().init(
        MediaQuery.of(context).size, Screen.getScreenOrientation(context));
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildGreeting(this.context),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 40.0.fs,
                  child: DefaultCustomButton(
                    bgColor: ColorSelect.blueAccent,
                    borderColor: ColorSelect.blueAccent,
                    text: 'Einloggen mit Microsoft',
                    textColor: Colors.white,
                    onPress: () {
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
          padding: EdgeInsets.fromLTRB(0.0, 55.0.fs, 0.0, 0.0),
          child: Text('Guten',
              style: TextStyle(
                  fontSize: 65.0.fs,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 125.0.fs, 0.0, 0.0),
          child: Text('Tag',
              style: TextStyle(
                  fontSize: 65.0.fs,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(110.0.fs, 125.0.fs, 0.0, 0.0),
          child: Text('.',
              style: TextStyle(
                  fontSize: 65.0.fs,
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
        title: Text(
          "Login speichern",
          style: TextStyle(
            fontSize: 10.0.fs,
          ),
        ),
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
        Text(
          'Probleme?',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 10.0.fs,
          ),
        ),
        const SizedBox(width: 5.0),
        InkWell(
          onTap: () async {
            EmailPopUp(
                    context: context,
                    to: "admin@gmail.com",
                    subject: "Frage bei Rfid CardManagement App",
                    body: " Guten Tag Admin,")
                .show(
                    //send to mail
                    );
          },
          child: Text(
            'Stelle Sie eine Frage.',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 10.0.fs,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  void sigIn() async {
    var loginStatus = await SessionUser.login(rememberValue);
    if (loginStatus != null) {
      switch (loginStatus.item1) {
        case LoginStatusType.ALREADYLOGGEDIN:
          Navigator.pushNamedAndRemoveUntil(
              context, "/clientnavigation", (Route<dynamic> route) => false);
          break;

        case LoginStatusType.NEWLOGIN:
          if (await SessionUser.signUp(
              context, loginStatus.item2, rememberValue)) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/clientnavigation", (Route<dynamic> route) => false);
          }
          break;
        case LoginStatusType.ERROR:
          SnackbarBuilder(
                  context: context,
                  header: "Error",
                  snackbarType: SnackbarType.failure,
                  content: loginStatus.item2)
              .build();
          break;
      }
    }
  }
}
