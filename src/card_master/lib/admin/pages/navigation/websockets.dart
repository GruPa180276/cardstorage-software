import 'dart:async';
import 'dart:io';

import 'package:card_master/admin/config/token_manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websockets {
  static List<WebSocketChannel> channels = [];
  static List<String> messages = [];

  void initState() {
    setupWebSockets();
  }

  static WebSocketChannel getSingleChannels() {
    return channels[0];
  }

  static List<WebSocketChannel> getChannels() {
    return channels;
  }

  static void handleMessage(data) {
    messages.add(data);
  }

  static List<String> getMessage() {
    return messages;
  }

  static void setupWebSockets() async {
    List<String> urls = [
      'wss://10.0.2.2:7171/api/v1/controller/log',
      'wss://10.0.2.2:7171/api/v1/storages/log',
      'wss://10.0.2.2:7171/api/v1/storages/cards/log',
      'wss://10.0.2.2:7171/api/v1/reservations/log',
      'wss://10.0.2.2:7171/api/v1/users/log',
    ];

    for (String url in urls) {
      WebSocketChannel channel = IOWebSocketChannel.connect(
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${await SecureStorage.getToken()}",
          "Accept": "application/json"
        },
        Uri.parse(url),
      )..stream.asBroadcastStream().listen((data) => handleMessage(data));
      channels.add(channel);
    }

    messages.add(
      "All Websockets are connected ...\n\n"
      "wss://10.0.2.2:7171/api/v1/controller/log\n"
      "wss://10.0.2.2:7171/api/v1/storages/log\n"
      "wss://10.0.2.2:7171/api/v1/storages/cards/log\n"
      "wss://10.0.2.2:7171/api/v1/reservations/log\n"
      "wss://10.0.2.2:7171/api/v1/users/log",
    );
  }

  static void dispose() {
    for (WebSocketChannel channel in Websockets.getChannels()) {
      channel.sink.close();
    }
  }
}
