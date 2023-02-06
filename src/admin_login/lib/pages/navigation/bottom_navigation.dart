import 'dart:io';

import 'package:admin_login/config/token_manager.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/log/logs.dart';
import 'package:admin_login/pages/card/cards.dart';
import 'package:admin_login/pages/status/status.dart';
import 'package:admin_login/pages/storage/storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  List<WebSocketChannel> _channels = [];
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _setupWebSockets();
  }

  void handleMessage(data) {
    setState(() {
      messages.add(data);
    });
  }

  void _setupWebSockets() async {
    List<String> urls = [
      'wss://10.0.2.2:7171/api/controller/log',
      'wss://10.0.2.2:7171/api/storages/log',
      'wss://10.0.2.2:7171/api/storages/cards/log',
      'wss://10.0.2.2:7171/api/reservations/log',
      'wss://10.0.2.2:7171/api/users/log',
    ];

    for (String url in urls) {
      IOWebSocketChannel channel = IOWebSocketChannel.connect(
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${await SecureStorage.getToken()}",
          "Accept": "application/json"
        },
        Uri.parse(url),
      )..stream.listen((data) => handleMessage(data));
      _channels.add(channel);
    }

    messages.add("All Websockets are connected ...\n\n"
        "wss://10.0.2.2:7171/api/controller/log\n"
        "wss://10.0.2.2:7171/api/storages/log\n"
        "wss://10.0.2.2:7171/api/storages/cards/log\n"
        "wss://10.0.2.2:7171/api/users/log");
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> screens = [
      StatusView(),
      CardsView(),
      StorageView(),
      Logs(
        messages: messages,
        handle: this.handleMessage,
      ),
    ];

    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (value) => setState(() => currentIndex = value),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_bar_chart),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Karten',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage),
              label: 'Storage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Logs',
            ),
          ],
        ));
  }

  @override
  void dispose() {
    for (WebSocketChannel channel in _channels) {
      channel.sink.close();
    }
    super.dispose();
  }
}
