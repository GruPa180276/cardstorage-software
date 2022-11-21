import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:isolate';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:introductionisolates/mqtt_timer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Isolate Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Isolates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _start();
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
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              notification,
            ),
            ElevatedButton(onPressed: () => _start(), child: Text("data"))
          ],
        ),
      ),
    );
  }
}

class Params {
  static late BuildContext context;
}
