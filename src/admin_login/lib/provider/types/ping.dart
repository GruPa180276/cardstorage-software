import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

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

Future<Ping> pingStorage(String name) async {
  final response = await http.get(
    Uri.parse(adres.pingAdress + "/ping/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return Ping.fromJson(jsonResponse);
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return pingStorage(name);
  } else {
    throw Exception('Failed to ping Storage!');
  }
}
