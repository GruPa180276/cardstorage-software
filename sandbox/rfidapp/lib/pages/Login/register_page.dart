import 'package:rfidapp/pages/Login/login_page.dart';

import 'package:flutter/material.dart';
import 'package:rfidapp/domain/validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKeyPasswort = GlobalKey<FormState>();
  final _formKeyPasswortRepeat = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyLastname = GlobalKey<FormState>();
  final _formKeyFirstname = GlobalKey<FormState>();
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
    // TODO: implement initState
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
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(children: <Widget>[
          buildRegisterText(this.context),
          const SizedBox(
            height: 15,
          ),
          buildFirstName(this.context),
          buildLastName(this.context),
          buildEmail(this.context),
          buildPassword(this.context),
          buildRepeatPassword(this.context),
          buildProgressbar(this.context),
          const SizedBox(
            height: 30,
          ),
          buildCreateAccount(this.context),
          const SizedBox(
            height: 15,
          ),
          buildGetback(this.context),
        ]),
      ),
    );
  }

  Widget buildFirstName(BuildContext context) {
    return Form(
      key: _formKeyFirstname,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
        // ignore: prefer_const_constructors
        child: TextFormField(
          controller: firstnameController,
          onChanged: (value) {
            _formKeyFirstname.currentState!.validate();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Bitte Vorname angeben";
            } else if (!Validator().validateName(value)) {
              return "Vorname nicht korrekt";
            }
            return null;
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Vorname',
          ),
        ),
      ),
    );
  }

  Widget buildLastName(BuildContext context) {
    return Form(
      key: _formKeyLastname,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
        // ignore: prefer_const_constructors
        child: TextFormField(
          controller: lastNameController,
          onChanged: (value) {
            _formKeyLastname.currentState!.validate();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Bitte Nachname angeben";
            } else if (!Validator().validateName(value)) {
              return "Nachname nicht korrekt";
            }
            return null;
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Nachname',
          ),
        ),
      ),
    );
  }

  Widget buildRegisterText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 35, left: 0, right: 0),
      // ignore: prefer_const_constructors
      child: const Text('Registrierung',
          style: TextStyle(
              fontSize: 53.0, fontWeight: FontWeight.w900, fontFamily: "Lato")),
    );
  }

  Widget buildEmail(BuildContext context) {
    return Form(
      key: _formKeyEmail,
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
        // ignore: prefer_const_constructors
        child: TextFormField(
          onChanged: (value) {
            _formKeyEmail.currentState!.validate();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Bitte E-Mail angeben";
            } else if (!Validator().validateEmail(value)) {
              return "Email nicht korrekt";
            }
            return null;
          },
          controller: emailController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Email',
          ),
        ),
      ),
    );
  }

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
                prefixIcon: Icon(Icons.person),
                labelText: 'Password',
              ),
              onChanged: (value) {
                _formKeyPasswort.currentState!.validate();
                setState(() {
                  passwordStrength = Validator().validatePassword(value);
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

  Widget buildGetback(BuildContext context) {
    return SizedBox(
        width: 500,
        height: 60,
        child: OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              width: 2.5,
              color: Theme.of(context).primaryColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          child: Text(
            "Zurück",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ));
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
