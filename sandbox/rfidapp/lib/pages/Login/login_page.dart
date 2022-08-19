import 'package:flutter/material.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/pages/Home/home_page.dart';
import 'package:rfidapp/pages/Login/register_page.dart';
import 'package:rfidapp/pages/navigation/menu_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberValue = false;
  bool isLoading = false;
  late bool isDark;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildGreeting(this.context),
            buildEmail(this.context),
            const SizedBox(
              height: 9,
            ),
            buildPassword(this.context),
            buildRememberMe(this.context),
            const SizedBox(
              height: 20,
            ),
            buildSignIn(context),
            const SizedBox(
              height: 15,
            ),
            buildCreateAccount(this.context),
            const SizedBox(
              height: 15,
            ),
            buildChangePassword(context)
          ],
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

  Widget buildEmail(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 35, left: 0, right: 0),
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'E-Mail',
        ),
      ),
    );
  }

  Widget buildPassword(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
      child: TextFormField(
        controller: passwordController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password',
        ),
        obscureText: true,
      ),
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

  Widget buildCreateAccount(BuildContext context) {
    return SizedBox(
        width: 500,
        height: 60,
        child: OutlinedButton.icon(
          icon: Icon(
            Icons.create,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            "Erstelle einen Account",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const RegisterScreen()));
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
        ));
  }

  Widget buildSignIn(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          //check if login was succesfull (email and password are vaild)
          //TODO if not then change rememberState and rememberValue to false
          if (rememberValue) {
            UserSecureStorage.setUsername(emailController.text);
            UserSecureStorage.setPassword(passwordController.text);
          }
          UserSecureStorage.setRememberState(rememberValue.toString());
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage())); //open app
        },
        // style: ElevatedButton.styleFrom(
        //   padding: const EdgeInsets.fromLTRB(150, 15, 150, 15),

        // ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ))),
        child: Text(
          'SIGN IN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
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
            Navigator.of(context).pushNamed('/signup');
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
}
