import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rfidapp/domain/storage_properties.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';
import 'dart:async';

class Data {
  static String uriRaspi = 'https://10.0.2.2:7171/api/';

  static Future<Storage?> getStorageData() async {
    try {
      var cardsResponse = await get(
          Uri.parse(
              "${uriRaspi}storages/name/${StorageProperties.getStorageId()}"),
          headers: {"Accept": "application/json"});
      var jsonStorage = jsonDecode(cardsResponse.body);
      Storage cards = Storage.fromJson(jsonStorage);

      return cards;
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Response?> getUserData(String accessToken) async {
    try {
      final response =
          await get(Uri.parse("https://graph.microsoft.com/v1.0/me"), headers: {
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
        "Accept": "application/json"
      });

      return response;
    } catch (e) {}
  }
}
