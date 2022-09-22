import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/account/change_password.dart';
import 'package:rfidapp/pages/login/login_page.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';

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
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
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
                      child: buttonField(
                        bgColor: ColorSelect.blueAccent,
                        borderColor: ColorSelect.blueAccent,
                        text: 'Passwort aendern',
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()));
                        },
                      )),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 50,
                        child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: buttonField(
                              bgColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              borderColor: Theme.of(context).primaryColor,
                              text: 'Abbrechen',
                              textColor: Theme.of(context).primaryColor,
                              onPress: () {
                                Navigator.pop(context);
                              },
                            )),
                      )),
                      const SizedBox(width: 20),
                      Expanded(
                          child: SizedBox(
                        height: 50,
                        child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: buttonField(
                              bgColor: ColorSelect.blueAccent,
                              borderColor: ColorSelect.blueAccent,
                              text: 'Speichern',
                              textColor: Colors.white,
                              onPress: () {},
                            )),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
