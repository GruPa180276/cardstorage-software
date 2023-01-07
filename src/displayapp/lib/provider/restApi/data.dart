import 'dart:convert';
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

  static Future<Response> postGetCardNow(ReaderCard readerCard) async {
    // "/api/storages/cards/name/NAME/fetch/user/email/USER@PROVIDER.COM",
    // "/api/storages/cards/name/NAME/fetch",

    String readerCards = jsonEncode(readerCard.toJson());
    return put(
        Uri.parse('${uriRaspi}storages/cards/name/${readerCard.name}/fetch'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
  }
}
