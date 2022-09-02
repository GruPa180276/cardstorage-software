import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/email.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';

class PasswordForgetSecreen extends StatefulWidget {
  const PasswordForgetSecreen({Key? key}) : super(key: key);

  @override
  State<PasswordForgetSecreen> createState() => PpasswordForgetSecreenState();
}

class PpasswordForgetSecreenState extends State<PasswordForgetSecreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 125,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Passwort vergessen",
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor)),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextInput(
                  inputController: emailController,
                  label: 'E-Mail',
                  iconData: Icons.email,
                  validator: Validator.funcEmail,
                  obsecureText: false,
                ),
              ),
              Text(
                'Falls Sie noch keinen Account haben erstellen Sie einen',
                style: TextStyle(color: Theme.of(context).dividerColor),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: buttonField(
                    bgColor: ColorSelect.blueAccent,
                    borderColor: ColorSelect.blueAccent,
                    text: 'Passwort zuruecksetzen',
                    textColor: Colors.white,
                    onPress: () {
                      sendMail();
                    },
                  )),
            ],
          ),
        ));
  }

  void sendMail() {
    const name = 'Firtz Bauer';
    final email = emailController.text;
    const subject = 'RfidApp Passwort zuruecksetzen';
    const message =
        'Sehr geehrter Herr $name\nSie haben angefragt Ihr Passwort zu aendern\n httpsa \n\n Beste Gruese\nIhre RfidApp Team';
    Email.sendEmail(
        name: name, email: email, subject: subject, message: message);
  }
}
