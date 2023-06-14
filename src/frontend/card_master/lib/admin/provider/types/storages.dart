import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:card_master/admin/provider/types/cards.dart';

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
    List<Cards> cards =
        tagObjsJson.map((tagJson) => Cards.fromJson(tagJson)).toList();

    return Storages(
        name: json['name'] ?? "",
        location: json['location'] ?? 0,
        numberOfCards: json['capacity'] ?? 0,
        cards: cards);
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'capacity': numberOfCards,
        'address': "0.0.0.0",
      };
}

Future<Response> fetchStorages() async {
  return await get(
    Uri.parse(storageAdress),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> getStorageByName(Map<String, dynamic> data) async {
  return await get(
    Uri.parse("$storageAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> getAllCardsPerStorage(Map<String, dynamic> data) async {
  return await get(
    Uri.parse("$storageAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> getUnfocusedStorage(Map<String, dynamic> data) async {
  return await get(
    Uri.parse("$storageAdress/focus/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> focusStorage(Map<String, dynamic> data) async {
  return await put(
    Uri.parse("$storageAdress/focus/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Content-Type": "application/json"
    },
  );
}

Future<Response> deleteStorage(Map<String, dynamic> data) async {
  return await delete(
    Uri.parse("$storageAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Content-Type": "application/json"
    },
  );
}

Future<Response> updateStorage(Map<String, dynamic> data) async {
  return await put(
    Uri.parse("$storageAdress/name/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data["data"]),
  );
}

Future<Response> addStorage(Map<String, dynamic> data) async {
  return await post(
    Uri.parse(storageAdress),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Content-Type": "application/json"
    },
    body: jsonEncode(data["data"]),
  );
}
