import 'package:flutter/material.dart';
import 'package:rfidapp/domain/email.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/Widget/textInputField.dart';
import 'package:rxdart/rxdart.dart';

class PasswordForgetSecreen extends StatefulWidget {
  const PasswordForgetSecreen({Key? key}) : super(key: key);

  @override
  State<PasswordForgetSecreen> createState() => PpasswordForgetSecreenState();
}

class PpasswordForgetSecreenState extends State<PasswordForgetSecreen> {
  TextEditingController emailController = new TextEditingController();
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
          child: Container(
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
                SizedBox(
                  height: 30,
                ),
                buildSendMail(context)
              ],
            ),
          ),
        ));
  }

  Widget buildSendMail(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            print(emailController.text);
            if (_formKey.currentState!.validate()) {
              //TODO look if email is available in db and get values name...
              final name = 'Firtz Bauer';
              final email = emailController.text;
              final subject = 'RfidApp Passwort zuruecksetzen';
              final message = 'Sehr geehrter Herr ' +
                  name +
                  '\nSie haben angefragt Ihr Passwort zu aendern\n httpsa \n\n Beste Gruese\nIhre RfidApp Team';
              Email.sendEmail(
                  name: name, email: email, subject: subject, message: message);
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ))),
          child: const Text(
            'Passwort zuruecksetzen',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
