import 'package:flutter/material.dart';
import 'package:login/user_Secure_Storage.dart';
import 'package:login/Colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 1, 216, 89),
          secondary: const Color(0xFFFFC107),
        ),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rememberValue = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //get value of textbox using "TextEditingController" emailController.text

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Scaffold(
      // backgroundColor: Color.fromARGB(165, 5, 19, 64),
      body: Column(
        children: [
          const Text(
            'Hello\nThere',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Container(
            padding: const EdgeInsets.all(70),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'E-Mail',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  CheckboxListTile(
                    title: const Text("Remember me"),
                    contentPadding: EdgeInsets.zero,
                    value: rememberValue,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (newValue) {
                      setState(() {
                        rememberValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //check if login was succesfull (email and password are vaild)
                      //TODO if not then change rememberState and rememberValue to false
                      if (rememberValue) {
                        UserSecureStorage.setUsername(emailController.text);
                        UserSecureStorage.setPassword(passwordController.text);
                      }
                      UserSecureStorage.setRememberState(
                          rememberValue.toString());
                    },
                    // style: ElevatedButton.styleFrom(
                    //   padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    // ),

                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ))),

                    child: const Text('Sign Up'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change Password'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
