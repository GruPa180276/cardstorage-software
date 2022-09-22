import 'package:flutter/material.dart';
import 'package:rfidapp/domain/validator.dart';

class createPassword extends StatelessWidget {
  final _formKeyPasswort = GlobalKey<FormState>();
  final _formKeyPasswortRepeat = GlobalKey<FormState>();
  Color borderColor = Colors.black;

  double passwordStrength = 0;
  bool disableRepeatPassword = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  createPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Column(
        children: [
          buildPassword(context, setState),
          buildRepeatPassword(context, setState),
          buildProgressbar(context, setState)
        ],
      );
    });
  }

  Widget buildPassword(BuildContext context, Function setState) {
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

  Widget buildRepeatPassword(BuildContext context, Function setState) {
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

  Widget buildProgressbar(BuildContext context, Function setState) {
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
}
