import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:card_master/admin/config/token_manager.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';

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
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        FeedbackBuilder(
          context: context,
          header: "Error!",
          snackbarType: FeedbackType.failure,
          content: e.toString(),
        ).build();
      }
    }
    return null;
  }
}
