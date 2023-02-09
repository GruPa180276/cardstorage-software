import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

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

Future<List<Users>> fetchUsers() async {
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
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return fetchUsers();
  } else {
    throw Exception('Failed to get Users!');
  }
}

Future<int> updateData(String email, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(adres.usersAdress + "/email/" + email),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return updateData(email, data);
  } else {
    throw Exception('Failed to update User!');
  }
}

Future<int> deleteUser(String email) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.usersAdress + "/email/" + email),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return response.statusCode;
  } else if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return deleteUser(email);
  } else {
    throw Exception('Failed to delete User!');
  }
}

Future<int> addUser(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(adres.usersAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return addUser(data);
  } else {
    throw Exception('Failed to add User!');
  }
}
