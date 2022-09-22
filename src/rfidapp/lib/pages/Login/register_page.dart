import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/generate/widget/createPassword.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKeyPasswort = GlobalKey<FormState>();

  final _formKeyPasswortRepeat = GlobalKey<FormState>();

  final formkey = GlobalKey<FormState>();
  Color borderColor = Colors.black;

  double passwordStrength = 0;
  bool disableRepeatPassword = true;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Brightness brightness =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .platformBrightness;
    if (brightness == Brightness.dark) {
      borderColor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        toolbarHeight: 100,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text("Registrierung",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor)),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            const SizedBox(height: 20),
            Form(
                key: formkey,
                child: Column(children: [
                  TextInput(
                    inputController: firstnameController,
                    label: 'Vorname',
                    iconData: Icons.person,
                    validator: Validator.funcName,
                    obsecureText: false,
                  ),
                  const SizedBox(height: 20),
                  TextInput(
                    inputController: lastNameController,
                    label: 'Nachname',
                    iconData: Icons.person,
                    validator: Validator.funcName,
                    obsecureText: false,
                  ),
                  const SizedBox(height: 20),
                  TextInput(
                    inputController: emailController,
                    label: 'E-Mail',
                    iconData: Icons.email,
                    validator: Validator.funcEmail,
                    obsecureText: false,
                  ),
                ])),
            createPassword(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: double.infinity,
                height: 60,
                child: buttonField(
                  bgColor: ColorSelect.blueAccent,
                  borderColor: ColorSelect.blueAccent,
                  text: 'Erstelle einen Account',
                  textColor: Colors.white,
                  onPress: () {
                    if (formkey.currentState!.validate()) {}
                  },
                )),
          ]),
        ),
      ),
    );
  }

//TODO export password scaffold into own file
}
