import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';

class Data {
  static String uri = 'http://10.0.2.2:7171/';

  static Future<Response> getData(String type) async {
    final response = await get(Uri.parse(uri + type),
        headers: {"Accept": "application/json"});
    return response;
  }

  static void postData(String type, Map<String, dynamic> datas) async {
    await post(Uri.parse("http://10.0.2.2:7171/card"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }

  static void putData(String type, Map<String, dynamic> datas) async {
    await put(Uri.parse("http://10.0.2.2:7171/card"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datas));
  }
}
