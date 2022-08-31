import 'package:flutter/material.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/Widget/textInputField.dart';

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
                buildSignIn(context)
              ],
            ),
          ),
        ));
  }

  Widget buildSignIn(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            print(emailController.text);
            if (_formKey.currentState!.validate()) {
              //TODO look if email is available in db

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
