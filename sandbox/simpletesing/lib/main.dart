import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: WebsocketDemo()));
}

class WebsocketDemo extends StatefulWidget {
  const WebsocketDemo({Key? key}) : super(key: key);

  @override
  State<WebsocketDemo> createState() => _WebsocketDemoState();
}

class _WebsocketDemoState extends State<WebsocketDemo> {
  final channel = IOWebSocketChannel.connect(
    'wss://10.0.2.2:7171/api/controller/log',
  );
  @override
  void initState() {
    super.initState();
    streamListener();
  }

  streamListener() {
    channel.stream.listen((message) {
      // channel.sink.add('received!');
      // channel.sink.close(status.goingAway);
      Map getData = jsonDecode(message);
      setState(() {});
      print(getData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueAccent, body: Icon(Icons.abc));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
