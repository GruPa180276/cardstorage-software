import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

class FocusS {
  String name;

  FocusS({
    required this.name,
  });

  factory FocusS.fromJson(dynamic json) {
    return FocusS(
      name: json ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

Future<List<FocusS>> getAllUnfocusedStorages() async {
  final response = await http.get(
    Uri.parse(adres.storageAdress + "/focus"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => FocusS.fromJson(data)).toList();
  } else if (response.statusCode == 401) {
    SecureStorage.setToken();
    return getAllUnfocusedStorages();
  } else {
    throw Exception('Failed to focus Storage!');
  }
}
