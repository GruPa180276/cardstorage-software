import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rfidapp/provider/restApi/api-parser.dart';
import 'package:rfidapp/provider/types/cards-status.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';
import 'dart:async';
import 'package:rfidapp/provider/types/storageproperties.dart';

class Data {
  static final String _ipAdress = StorageProperties.getIpAdress()!;
  static String uriRaspi = 'http://$_ipAdress:7171/api/';

  static Future<List<Cards>> getCardsData() async {
    try {
      var responseCards = await get(Uri.parse("${uriRaspi}cards"),
          headers: {"Accept": "application/json"});
      var responseCardsStatus = await get(Uri.parse("${uriRaspi}cards/status"),
          headers: {"Accept": "application/json"});
      var responseStorages = await get(Uri.parse("${uriRaspi}storage-units"),
          headers: {"Accept": "application/json"});

      List<Storage> storages = jsonDecode(responseStorages.body)
          .map<Storage>(Storage.fromJson)
          .toList();
      List<Cards> cards =
          jsonDecode(responseCards.body).map<Cards>(Cards.fromJson).toList();
      List<CardsStatus> cardsStatus = jsonDecode(responseCardsStatus.body)
          .map<CardsStatus>(CardsStatus.fromJson)
          .toList();
      ApiParser.combineCardDatas(cards, cardsStatus, storages);
      return cards;
    } catch (e) {
      print(e);
    }
    return List<Cards>.empty();
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

  static void postData(
      String type, Map<String, dynamic> datas, String adress) async {
    //TODO add try catch
    await post(Uri.parse(uriRaspi + type),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }



  /*
  Es war einmal ein Capybara. Es träumte von einer Welt voller Orangen und After Partys.
  Doch als die kleine Wossasau auf solch einer Veranstaltung aufpullte nahm ihr Leben eine
  drastische Wendung.... 
  */
}
