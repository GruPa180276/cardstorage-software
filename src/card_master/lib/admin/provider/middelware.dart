import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/admin/config/token_manager.dart';

class Data {
  static String? bearerToken;

  static Future<Response?> checkAuthorization(
      {BuildContext? context,
      required Function function,
      Map<String, dynamic>? args}) async {
    try {
      Response response;
      /*if (bearerToken == null) {
        SecureStorage.setToken();
      }*/
      response = (args != null) ? await function(args) : await function();

      if (response.statusCode == 401) {
        SecureStorage.setToken(context!);
        response = (args != null) ? await function(args) : await function();
      }
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return response;
    } catch (e) {
      if (context != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) => buildAlertDialog(
                  context,
                  "Error",
                  e.toString(),
                  [
                    generateButtonRectangle(
                      context,
                      "Ok",
                      () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    }
    return null;
  }
}
