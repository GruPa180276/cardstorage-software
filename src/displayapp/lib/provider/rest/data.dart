import 'dart:io';
import 'package:http/http.dart';
import 'package:rfidapp/provider/storage_properties.dart';
import 'dart:async';
import 'package:rfidapp/provider/websocket/websocket_callback.dart';

class Data {
  static String serverAdress =
      'https://${StorageProperties.getServer()}:${StorageProperties.getRestPort()}/api/v1/';
  static String? _bearerToken;

  static String? getBearerToken() {
    return _bearerToken;
  }

  static Future<Response> check(
      Function function, Map<String, dynamic>? args) async {
    Response response;
    if (_bearerToken == null) {
      await _generateToken();
    }
    if (args != null) {
      response = await function(args);
    } else {
      response = await function();
    }
    if (response.statusCode == 401) {
      await _generateToken();

      if (args != null) {
        response = await function(args);
      } else {
        response = await function();
      }
    }
    return response;
  }

  static Future<Response> getStorageData() async {
    return await get(
        Uri.parse(
            "${serverAdress}storages/name/${StorageProperties.getStorageName()}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $_bearerToken",
        });
  }

  static Future<Response> postGetCardNow(Map<String, dynamic> args) async {
    return put(
        Uri.parse(
            '${serverAdress}storages/cards/name/${args["cardname"]}/fetch'),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: "Bearer $_bearerToken",
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }

  static Future<void> _generateToken() async {
    var response = await get(
        Uri.parse(
            "${serverAdress}auth/user/email/${StorageProperties.getStorageUser()}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_bearerToken",
          "Content-Type": "text/plain",
        });
    _bearerToken = response.body;
    WebsocketCallBack.connectUserLog(_bearerToken!);
  }
}
