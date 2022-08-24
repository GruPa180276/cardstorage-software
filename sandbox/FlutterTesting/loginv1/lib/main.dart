import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomepage(),
    );
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);
  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final _formKey = GlobalKey<FormState>();
  // regular expression to check if string
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double passwordStrength = 0;
  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  //   1:   Great
  //A function that validate user entered password
  bool validatePassword(String pass) {
    String password = pass.trim();
    if (password.isEmpty) {
      setState(() {
        passwordStrength = 0;
      });
    } else if (password.length < 6) {
      setState(() {
        passwordStrength = 1 / 4;
      });
    } else if (password.length < 8) {
      setState(() {
        passwordStrength = 2 / 4;
      });
    } else {
      if (passValid.hasMatch(password)) {
        setState(() {
          passwordStrength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter password";
                    } else {
                      //call function to check password
                      bool result = validatePassword(value);
                      if (result) {
                        // create account event
                        return null;
                      } else {
                        return " Password should contain Capital, small letter & Number & Special";
                      }
                    }
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
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
              ElevatedButton(
                  onPressed: passwordStrength != 1
                      ? null
                      : () {
                          //perform click event
                        },
                  child: const Text("Submit form"))
            ],
          ),
        ),
      ),
    );
  }
}
