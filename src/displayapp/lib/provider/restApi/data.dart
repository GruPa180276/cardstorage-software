import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';

import 'package:rfidapp/provider/types/storageproperties.dart';

class Data {
  static String _ipAdress = StorageProperties.getIpAdress()!;
  static String uriRaspi = 'http://$_ipAdress:7171/';

  static Future<Response?> getCardsData() async {
    //on emulator: "http://10.0.2.2:7171/card"
    //http://localhost:7171/card
    print(Uri.parse(uriRaspi + "card"));
    try {
      final response = await get(Uri.parse(uriRaspi + "card"), headers: {
        //"key":"value" for authen.
        "Accept": "application/json"
      });
      return response;
    } catch (e) {}
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
}
