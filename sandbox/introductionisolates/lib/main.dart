import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:isolate';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:introductionisolates/mqtt_timer.dart';

import 'mqtt.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Isolate Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Isolates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _start();
  }

  late Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  late ReceivePort _receivePort;

  void _start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(
      _handleMessage,
    );
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      _counter++;
      sendPort.send(_counter.toString());
    });
  }

  void _handleMessage(dynamic data) {
    if (data == '10') {
      MqttTimer.startTimer(context);
    }
    setState(() {
      notification = data;
    });
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
        notification = '';
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      //_isolate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notification,
            ),
            ElevatedButton(
                onPressed: (() async {
                  MQTTClientManager mcm = new MQTTClientManager();
                  await mcm.connect();
                  mcm.subscribe("topic");
                  //MQTTClientManager().publishMessage("hello", "message");
                }),
                child: Text("data"))
          ],
        ),
      ),
    );
  }
}

class Params {
  static late BuildContext context;
}
