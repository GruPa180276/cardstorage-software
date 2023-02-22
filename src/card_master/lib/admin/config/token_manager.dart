import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/auth.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();
  static late String auth;

  static void setToken(BuildContext context) async {
    String mail = "card_storage_admin@default.com";

    var response = await Data.checkAuthorization(
      context: context,
      function: authAdminLogin,
      args: {"name": mail},
    );
    auth = response!.body;
    storage.write(key: "jwt", value: auth);
  }

  static Future<String?> getToken() async {
    String? token = await storage.read(key: "jwt");
    return token;
  }
}
