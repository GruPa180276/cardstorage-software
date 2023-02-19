import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/admin/config/token_manager.dart';

class Users {
  String email;
  String storage;
  bool privileged;

  Users({
    required this.email,
    required this.storage,
    required this.privileged,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      email: json['email'] ?? "",
      storage: json['storage'] ?? "",
      privileged: json['privileged'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
        'email': email,
        'privileged': privileged,
        'storage': storage,
      };
}

Future<Response> fetchUsers() async {
  return await get(
    Uri.parse(usersAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> updateData(Map<String, dynamic> data) async {
  return await put(
    Uri.parse(usersAdress + "/email/" + data["name"]),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data),
  );
}

Future<Response> deleteUser(Map<String, dynamic> data) async {
  return await delete(
    Uri.parse(usersAdress + "/email/" + data["name"]),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> addUser(Map<String, dynamic> data) async {
  return await post(
    Uri.parse(usersAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data["data"]),
  );
}
