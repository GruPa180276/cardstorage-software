import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';

import 'package:rfidapp/provider/types/readercards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class Data {
  static String uriRaspi = 'https://10.0.2.2:7171/api/';
  static String uriMsGraph = 'https://10.0.2.2:7171/';

  static Future<List<Storage>?> getStorageData() async {
    try {
      var cardsResponse = await get(Uri.parse("${uriRaspi}storages"),
          headers: {"Accept": "appliction/json"});

      var jsonStorage = jsonDecode(cardsResponse.body) as List;
      List<Storage> storages =
          jsonStorage.map((tagJson) => Storage.fromJson(tagJson)).toList();

      return storages;
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> checkUserRegistered(String email) async {
    var responseUser = await get(Uri.parse("${uriRaspi}users/email/${email}"),
        headers: {"Accept": "application/json"});
    print(
        "--------------------------------------------------------------------------------");

    if (responseUser.statusCode != 200) {
      return false;
    }
    return true;
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
