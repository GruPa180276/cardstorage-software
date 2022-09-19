import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';

class Data {
  static String uri = 'http://10.0.2.2:7171/';

  static Future<Response?> getData(String type) async {
    //on emulator: "http://10.0.2.2:7171/card"
    //http://localhost:7171/card
    try {
      final response = await get(Uri.parse(uri + type), headers: {
        //"key":"value" for authen.
        "Accept": "application/json"
      });
      return response;
    } catch (e) {
    }
  }

  static void postData(
      String type, Map<String, dynamic> datas, String adress) async {
    //TODO add try catch
    await post(Uri.parse(uri + type),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }

  static void putData(String type, Map<String, dynamic> datas) async {
    //TODO add try catch
    await put(Uri.parse(uri + type),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }
}
