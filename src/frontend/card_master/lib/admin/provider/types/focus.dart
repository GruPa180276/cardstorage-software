import 'dart:io';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/client/provider/rest/data.dart';

class FocusS {
  String name;

  FocusS({
    required this.name,
  });

  factory FocusS.fromJson(dynamic json) {
    return FocusS(
      name: json ?? "",
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

Future<Response> getAllUnfocusedStorages() async {
  return await get(
    Uri.parse("$storageAdress/focus"),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ${Data.getBearerToken()}",
      "Accept": "application/json"
    },
  );
}
