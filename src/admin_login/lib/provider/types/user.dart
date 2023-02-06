import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

class Users {
  String email;
  bool privileged;

  Users({
    required this.email,
    required this.privileged,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      email: json['email'] ?? "",
      privileged: json['privileged'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
        'privileged': privileged,
      };
}

Future<List<Users>> fetchData() async {
  final response = await http.get(
    Uri.parse(adres.usersAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Users.fromJson(data)).toList();
  } else if (response.statusCode == 401) {
    SecureStorage.setToken();
    return fetchData();
  } else {
    throw Exception('Failed to get Users!');
  }
}

Future<dynamic> updateData(String email, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(adres.usersAdress + "/email/" + email),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Users.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    SecureStorage.setToken();
    return updateData(email, data);
  } else {
    throw Exception('Failed to update User!');
  }
}

Future<dynamic> deleteData(String email) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.usersAdress + "/email/" + email),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return Users.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    SecureStorage.setToken();
    return deleteData(email);
  } else {
    throw Exception('Failed to delete User!');
  }
}
