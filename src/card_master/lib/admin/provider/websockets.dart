import 'dart:io';

import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websockets {
  static List<WebSocketChannel> channels = [];
  static List<String> messages = [];

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
      wssControler,
      wssStorage,
      wssCard,
      wssReservation,
      wssUser,
    ];

    for (String url in urls) {
      WebSocketChannel channel = IOWebSocketChannel.connect(
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
          "Accept": "application/json"
        },
        Uri.parse(url),
      )..stream.asBroadcastStream().listen((data) => handleMessage(data));
      channels.add(channel);
    }

    messages.add(
      "All Websockets are connected ...\n\n$wssControler\n$wssStorage\n$wssCard\n$wssReservation\n$wssUser\n",
    );
  }

  static void dispose() {
    for (WebSocketChannel channel in Websockets.getChannels()) {
      channel.sink.close();
    }
  }
}
