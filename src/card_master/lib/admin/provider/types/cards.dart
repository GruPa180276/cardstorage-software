import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/admin/config/token_manager.dart';

class Cards {
  String name;
  String storage;
  int position;
  int accessed;
  bool available;
  String reader;

  Cards({
    required this.name,
    required this.storage,
    required this.position,
    required this.accessed,
    required this.available,
    required this.reader,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      name: json['name'] ?? "",
      storage: json['storage'] ?? "",
      position: json['position'] ?? 0,
      accessed: json['accessed'] ?? 0,
      available: json['available'] ?? false,
      reader: json['reader'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'storage': storage,
        'accessed': accessed,
        'reader': reader,
        'available': available,
      };
}

Future<Response> fetchCards() async {
  return await get(
    Uri.parse(cardAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> getCardByName(Map<String, dynamic> data) async {
  return await get(
    Uri.parse("$cardAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> deleteCard(Map<String, dynamic> data) async {
  return await delete(
    Uri.parse("$cardAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> updateCard(Map<String, dynamic> data) async {
  return await put(
    Uri.parse("$cardAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data["data"]),
  );
}

Future<Response> addCard(Map<String, dynamic> data) async {
  return await post(
    Uri.parse(cardAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data["data"]),
  );
}
