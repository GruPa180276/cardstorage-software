import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/login/password_forget_page.dart';
import 'package:rfidapp/pages/login/register_page.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';
import 'package:rfidapp/pages/navigation/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberValue = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  // ignore: must_cal_super
  void initState() {
    init();
  }

  Future init() async {
    final rememberState = await UserSecureStorage.getRememberState() ?? '';
    if (rememberState == "true") {
      final email = await UserSecureStorage.getUsername() ?? '';
      final password = await UserSecureStorage.getPassword() ?? '';
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        if (rememberState == "true") {
          rememberValue = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildGreeting(this.context),
              const SizedBox(height: 20),
              TextInput(
                  inputController: emailController,
                  label: 'E-Mail',
                  iconData: Icons.email,
                  validator: Validator.funcEmail,
                  obsecureText: false),
              const SizedBox(height: 20),
              TextInput(
                  inputController: passwordController,
                  label: 'Password',
                  iconData: Icons.lock,
                  validator: Validator.funcPassword,
                  obsecureText: true),
              buildRememberMe(this.context),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: buttonField(
                    bgColor: ColorSelect.blueAccent,
                    borderColor: ColorSelect.blueAccent,
                    text: 'SIGN IN',
                    textColor: Colors.white,
                    onPress: () {
                      sigIn();
                    },
                  )),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: buttonField(
                  bgColor: Theme.of(context).scaffoldBackgroundColor,
                  borderColor: Theme.of(context).primaryColor,
                  text: 'Erstelle einen Account',
                  textColor: Theme.of(context).primaryColor,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              buildChangePassword(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGreeting(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
          child: const Text('Guten',
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 175.0, 0.0, 0.0),
          child: const Text('Tag',
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato")),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(130.0, 175.0, 0.0, 0.0),
          child: Text('.',
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Lato",
                  color: Theme.of(context).secondaryHeaderColor)),
        )
      ],
    );
  }

  Widget buildRememberMe(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 0),
      child: CheckboxListTile(
        visualDensity: VisualDensity.compact,
        activeColor: Theme.of(context).secondaryHeaderColor,
        title: const Text("Remember me"),
        //contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
        value: rememberValue,

        onChanged: (newValue) {
          setState(() {
            rememberValue = newValue!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget buildChangePassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Password vergessen?',
          style: TextStyle(fontFamily: 'Lato'),
        ),
        const SizedBox(width: 5.0),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PasswordForgetSecreen()));
          },
          child: Text(
            'Passwort ändern',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  void sigIn() {
    if (_formKey.currentState!.validate()) {
      if (rememberValue) {
        UserSecureStorage.setUsername(emailController.text);
        UserSecureStorage.setPassword(passwordController.text);
      }
      UserSecureStorage.setRememberState(rememberValue.toString());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavigation()));
    } //open app}
  }
}
