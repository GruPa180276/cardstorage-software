import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/admin/config/token_manager.dart';

class Ping {
  String name;
  int time;

  Ping({
    required this.name,
    required this.time,
  });

  factory Ping.fromJson(dynamic json) {
    return Ping(
      name: json['name'] ?? "",
      time: json['time'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'time': time,
      };
}

Future<Response> pingStorage(Map<String, dynamic> data) async {
  return await get(
    Uri.parse(pingAdress + "/ping/name/" + data["name"]),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}
