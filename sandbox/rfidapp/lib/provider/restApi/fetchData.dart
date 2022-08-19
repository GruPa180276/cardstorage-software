import 'package:rfidapp/provider/dataType/data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:rfidapp/provider/dataType/user.dart';
import 'package:rfidapp/provider/dataType/cards.dart';

class FetchData {
  static Future<http.Response> getData(String type) async {
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });
    return response;
  }
}
