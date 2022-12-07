import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:rfidapp/provider/types/cards-status.dart';
import 'package:rfidapp/provider/types/cards-wrapper.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'dart:async';

import 'package:rfidapp/provider/types/storageproperties.dart';

class Data {
  static String _ipAdress = StorageProperties.getIpAdress()!;
  static String uriRaspi = 'http://$_ipAdress:7171/api/';

  static Future<List<Cards>> getCardsData() async {
    print(uriRaspi + "cards");
    var responseCards = await get(Uri.parse(uriRaspi + "cards"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });

    var responseCardsStatus =
        await get(Uri.parse(uriRaspi + "cards/status"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });

    print("responseCards");

    return jsonDecode(responseCards.body).map<Cards>(Cards.fromJson).toList();
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

  static void putData(String type, Map<String, dynamic> datas) async {
    //TODO add try catch
    await put(Uri.parse(uriRaspi + type),
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
