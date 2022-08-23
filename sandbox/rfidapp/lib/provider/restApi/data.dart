import 'package:http/http.dart' as http;
import 'dart:async';

class FetchData {
  static Future<http.Response> getData(String type) async {
    Uri uri = Uri(
      port: 7171,
      host: "localhost",
      path: "card",
    );
    print(uri.toString());
    //on emulator: "http://10.0.2.2:7171/card"
    //http://localhost:7171/card
    http.Response response =
        await http.get(Uri.parse("http://localhost:7171/card/"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });
    return response;
  }
}
