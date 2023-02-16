import 'dart:convert';
import 'dart:io';
import 'package:card_master/admin/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:card_master/admin/provider/types/cards.dart';
import 'package:card_master/admin/config/adress.dart' as adres;

class Storages {
  String name;
  String location;
  int numberOfCards;
  List<Cards> cards;

  Storages({
    required this.name,
    required this.location,
    required this.numberOfCards,
    required this.cards,
  });

  factory Storages.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['cards'] as List;
    List<Cards> _cards =
        tagObjsJson.map((tagJson) => Cards.fromJson(tagJson)).toList();

    return Storages(
        name: json['name'] ?? "",
        location: json['location'] ?? 0,
        numberOfCards: json['capacity'] ?? 0,
        cards: _cards);
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'capacity': numberOfCards,
        'address': "0.0.0.0",
      };
}

Future<http.Response> fetchStorages() async {
  return await http.get(
    Uri.parse(adres.storageAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Storages> getStorageByName(String name) async {
  final response = await http.get(
    Uri.parse(adres.storageAdress + "/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return Storages.fromJson(jsonResponse);
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return getStorageByName(name);
  } else {
    throw Exception('Failed to get current Storage!');
  }
}

Future<Storages> getAllCardsPerStorage(String name) async {
  final response = await http.get(
    Uri.parse(adres.storageAdress + "/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return getAllCardsPerStorage(name);
  } else {
    throw Exception('Failed to get Cards of Storage!');
  }
}

Future<Storages> getUnfocusedStorages(String name) async {
  final response = await http.get(
    Uri.parse(adres.storageAdress + "/focus/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return getUnfocusedStorages(name);
  } else {
    throw Exception('Failed to get all unfocused Storages!');
  }
}

Future<int> focusStorage(String name) async {
  final http.Response response = await http.put(
    Uri.parse(adres.storageAdress + "/focus/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return focusStorage(name);
  } else {
    throw Exception('Failed to update Storage!');
  }
}

Future<int> deleteStorage(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.storageAdress + "/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return response.statusCode;
  } else if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return deleteStorage(name);
  } else {
    throw Exception('Failed to delete Storage!');
  }
}

Future<int> updateStorage(String name, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(adres.storageAdress + "/name/" + name),
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
    return updateStorage(name, data);
  } else {
    throw Exception('Failed to update Storage!');
  }
}

Future<int> addStorage(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(adres.storageAdress),
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
    return addStorage(data);
  } else {
    throw Exception('Failed to add Storage!');
  }
}
