import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/provider/types/cards.dart';
import 'package:admin_login/config/adress.dart' as adres;

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

Future<List<Storages>> fetchData() async {
  final response = await http.get(
    Uri.parse(adres.storageAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Storages.fromJson(data)).toList();
  } else {
    throw Exception('Failed to get Storages!');
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
  } else {
    throw Exception('Failed to get Cards of Storage!');
  }
}

Future<Storages> getUnfocusedStorage(String name) async {
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
  } else {
    throw Exception('Failed to get all unfocused Storages!');
  }
}

Future<Storages> focusStorage(String name) async {
  final http.Response response = await http.put(
    Uri.parse(adres.storageAdress + "/focus/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );

  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update Storage!');
  }
}

Future<Storages> deleteData(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.storageAdress + "/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Storage!');
  }
}

Future<Storages> updateData(String name, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(adres.storageAdress + "/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update Storage!');
  }
}

Future<Storages> sendData(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(adres.storageAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to add Storage!');
  }
}
