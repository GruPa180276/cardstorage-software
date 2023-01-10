import 'dart:convert';
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
  );
  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return Ping.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to ping Storage!');
  }
}
