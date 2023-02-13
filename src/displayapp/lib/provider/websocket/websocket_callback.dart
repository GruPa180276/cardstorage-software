import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:rfidapp/pages/widgets/pop_up/request_timer.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/domain/storage_properties.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketCallBack {
  static IOWebSocketChannel? channel;
  static bool _isConnected = false;
  static BuildContext? _buildContext;
  static void connectUserLog(String bearerToken) {
    if (_isConnected) {
      channel!.sink.close();
    }
    channel = IOWebSocketChannel.connect(
        "wss://${StorageProperties.getServer()}:${StorageProperties.getRestPort()}/api/v1/users/log",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          'Accept': 'application/json'
        });
    _isConnected = true;
    _streamListener();
  }

  static void reconnect() {
    channel!.sink.close();
    channel = IOWebSocketChannel.connect(
        Uri.parse(
            'wss://${StorageProperties.getServer()}:${StorageProperties.getRestPort()}/api/users/log'),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
          'Accept': 'application/json'
        });
    _isConnected = true;
    _streamListener();
  }

  static bool getIsConnected() {
    return _isConnected;
  }

  static _streamListener() {
    channel?.stream.listen((message) async {
      var responseData = jsonDecode(message);

      if (responseData["client-id"] ==
          "${StorageProperties.getStorageName()}@${StorageProperties.getLocation()}") {
        await RequestTimer(context: _buildContext!).build();
      }
    });
  }

  static void setBuildContext(BuildContext buildContext) {
    _buildContext = buildContext;
  }
}
