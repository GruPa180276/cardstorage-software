import 'package:flutter/material.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKeyPasswort = GlobalKey<FormState>();
  final _formKeyPasswortRepeat = GlobalKey<FormState>();
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
            TextInput(
              inputController: firstnameController,
              label: 'Vorname',
              iconData: Icons.person,
              validator: Validator.funcName,
              obsecureText: false,
            ),
            TextInput(
              inputController: lastNameController,
              label: 'Nachname',
              iconData: Icons.person,
              validator: Validator.funcName,
              obsecureText: false,
            ),
            TextInput(
              inputController: emailController,
              label: 'E-Mail',
              iconData: Icons.email,
              validator: Validator.funcEmail,
              obsecureText: false,
            ),
            buildPassword(this.context),
            buildRepeatPassword(this.context),
            buildProgressbar(this.context),
            const SizedBox(
              height: 30,
            ),
            buildCreateAccount(this.context),
          ]),
        ),
      ),
    );
  }

//TODO export password scaffold into own file
  Widget buildPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: Form(
        key: _formKeyPasswort,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                errorStyle: TextStyle(),
                prefixIcon: Icon(Icons.person),
                labelText: 'Password',
              ),
              onChanged: (value) {
                _formKeyPasswort.currentState!.validate();
                setState(() {
                  passwordStrength = Validator.validatePassword(value);
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter password";
                } else {
                  //call function to check password

                  if (passwordStrength == 1) {
                    setState(() {
                      disableRepeatPassword = false;
                    });
                    return null;
                  } else {
                    setState(() {
                      disableRepeatPassword = true;
                    });
                    repeatPasswordController.text = '';
                    return " Password should contain Capital, small letter & Number & Special";
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRepeatPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: Form(
        key: _formKeyPasswortRepeat,
        child: Column(
          children: [
            TextFormField(
              controller: repeatPasswordController,
              readOnly: disableRepeatPassword,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Passwort wiederholen',
              ),
              onChanged: (value) {
                _formKeyPasswortRepeat.currentState!.validate();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter password";
                } else {
                  if (passwordController.text !=
                      repeatPasswordController.text) {
                    return "Die Passwoerte sind nicht ident";
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
    //        readOnly: true,
  }

  Widget buildProgressbar(BuildContext context) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.only(top: 40, left: 0, right: 0),
        child: LinearProgressIndicator(
          value: passwordStrength,
          backgroundColor: Colors.grey[300],
          minHeight: 5,
          color: passwordStrength <= 1 / 4
              ? Colors.red
              : passwordStrength == 2 / 4
                  ? Colors.yellow
                  : passwordStrength == 3 / 4
                      ? Colors.blue
                      : Colors.green,
        ),
      ),
      Container(
          padding: const EdgeInsets.fromLTRB(0.0, 22.0, 0.0, 0.0),
          child: const Text('Stärke Passwort',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Lato")))
    ]);
  }

  Widget buildCreateAccount(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          //TODO
        },
        // style: ElevatedButton.styleFrom(
        //   padding: const EdgeInsets.fromLTRB(150, 15, 150, 15),

        // ),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ))),
        child: const Text(
          'Erstelle einen Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
