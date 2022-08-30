import 'package:flutter/material.dart';
import 'package:login/notificationApi.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _State createState() => _State();
}

class _State extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter - tutorialskart.com'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  // NotificationApi.showNotification(
                  //     title: 'Sarah Abs',
                  //     body: 'I am simple not there',
                  //     payload: 'sarah.abs');
                },
                child: Text('Simple Notification')),
            ElevatedButton(
                onPressed: () {}, child: Text('Scheduled Notification')),
            ElevatedButton(onPressed: () {}, child: Text('Remove Notification'))
          ],
        ));
  }
}
