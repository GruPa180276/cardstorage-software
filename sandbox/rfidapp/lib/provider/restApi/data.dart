import 'package:http/http.dart' as http;
import 'dart:async';

class FetchData {
  static Future<http.Response> getData(String type) async {
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/$type"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });
    return response;
  }
}
