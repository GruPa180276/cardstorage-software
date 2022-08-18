import 'package:flutter/material.dart';
import 'package:login/user_simple_prefernce.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    isSwitched = UserSimplePreferences.getIsOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter - tutorialkart.com'),
        ),
        body: Center(
          child: Switch(
            value: isSwitched,
            onChanged: (value) async {
              await UserSimplePreferences.setIsOn(value);
              setState(() {
                isSwitched = value;
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ));
  }
}
