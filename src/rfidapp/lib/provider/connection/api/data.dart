import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:rfidapp/provider/connection/api/uitls.dart';
import 'dart:async';

import 'package:rfidapp/provider/types/readercard.dart';
import 'package:rfidapp/provider/types/storage.dart';
import 'package:rfidapp/provider/types/user.dart';

class Data {
  static String uriRaspi = 'https://10.0.2.2:7171/api/';

  static Future<List<ReaderCard>?> getReaderCards() async {
    try {
      var cardsResponse = await get(Uri.parse("${uriRaspi}storages"),
          headers: {"Accept": "appliction/json"});

      var jsonStorage = jsonDecode(cardsResponse.body) as List;
      List<Storage> storages =
          jsonStorage.map((tagJson) => Storage.fromJson(tagJson)).toList();

      return Utils.parseToReaderCards(storages);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> checkUserRegistered(String email) async {
    var responseUser = await get(Uri.parse("${uriRaspi}users/email/${email}"),
        headers: {"Accept": "application/json"});

    if (responseUser.statusCode != 200 ||
        jsonDecode(responseUser.body)["email"].toString().isEmpty) {
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

  static Future<Response> postCreateNewUser(
      String email, String storageName) async {
    return post(Uri.parse('${uriRaspi}users'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "storage": storageName}));
  }

  static Future<Response> postGetCardNow(
      ReaderCard readerCard, String email) async {
    // "/api/storages/cards/name/NAME/fetch/user/email/USER@PROVIDER.COM",
    // "/api/storages/cards/name/NAME/fetch",
    print(Uri.parse(
        '${uriRaspi}storages/cards/name/${readerCard.name}/fetch/user/email/${email}'));
    String readerCards = jsonEncode(readerCard.toJson());
    return put(
        Uri.parse(
            '${uriRaspi}storages/cards/name/${readerCard.name}/fetch/user/email/${email}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }
}
