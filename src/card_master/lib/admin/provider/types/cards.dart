import 'dart:convert';
import 'dart:io';
import 'package:card_master/admin/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:card_master/admin/config/adress.dart' as adres;

class Cards {
  String name;
  String storage;
  int position;
  int accessed;
  bool available;

  Cards({
    required this.name,
    required this.storage,
    required this.position,
    required this.accessed,
    required this.available,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      name: json['name'] ?? "",
      storage: json['storage'] ?? "",
      position: json['position'] ?? 0,
      accessed: json['accessed'] ?? 0,
      available: json['available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'storage': storage,
      };
}

Future<List<Cards>> fetchData() async {
  final response = await http.get(
    Uri.parse(adres.cardAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Cards.fromJson(data)).toList();
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return fetchData();
  } else {
    throw Exception('Failed to get Cards!');
  }
}

Future<int> deleteData(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.cardAdress + "/name/" + name),
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
    return deleteData(name);
  } else {
    throw Exception('Failed to delete Card!');
  }
}

Future<int> updateData(String name, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(adres.cardAdress + "/name/" + name),
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
    return updateData(name, data);
  } else {
    throw Exception('Failed to update Card!');
  }
}

Future<int> sendData(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(adres.cardAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 200) {
    return response.statusCode;
  }
  if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return sendData(data);
  } else {
    throw Exception('Failed to add Card!');
  }
}
