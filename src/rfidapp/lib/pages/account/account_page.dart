import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/Widget/textInputField.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController emailController = TextEditingController()
    ..text = 'Get data';
  TextEditingController firstNameController = TextEditingController()
    ..text = 'Get data';
  TextEditingController lastNameController = TextEditingController()
    ..text = 'Get data';
  TextEditingController birthDateController = TextEditingController()
    ..text = 'Get data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //drawer: const MenuNavigationDrawer(),
        appBar: AppBar(
          toolbarHeight: 100,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Account",
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: ColorSelect.greyBorderColor,
                      child: const Icon(
                        Icons.account_box,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.person,
                      inputController: firstNameController,
                      label: 'Vorname',
                      obsecureText: false,
                      validator: Validator.funcName),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.person,
                      inputController: lastNameController,
                      label: 'Nachname',
                      obsecureText: false,
                      validator: Validator.funcName),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.email,
                      inputController: emailController,
                      label: 'E-Mail',
                      obsecureText: false,
                      validator: Validator.funcEmail),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: buildButton('Passwort aendern')),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 50, child: buildButton('Abbrechen'))),
                      const SizedBox(width: 20),
                      Expanded(
                          child: SizedBox(
                              height: 50, child: buildButton('Speichern')))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildButton(String text) {
    Color colorbg = ColorSelect.blueAccent;
    Color colorText = Colors.white;
    Color colorBorder = ColorSelect.blueAccent;

    if (text == 'Abbrechen') {
      colorbg = Theme.of(context).scaffoldBackgroundColor;
      colorText = Theme.of(context).primaryColor;
      colorBorder = Theme.of(context).primaryColor;
    }

    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorbg),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  side: BorderSide(color: colorBorder, width: 2.2)))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorText,
        ),
      ),
    );
  }
}
