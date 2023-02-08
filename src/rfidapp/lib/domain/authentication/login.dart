import 'dart:convert';
import 'package:rfidapp/domain/authentication/authentication.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/login_status_type.dart';
import 'package:rfidapp/provider/rest/data.dart';
import 'package:rfidapp/provider/sessionUser.dart';
import 'package:tuple/tuple.dart';

class Login {
  static Future<Tuple2<LoginStatusType, String?>?> start(
      bool rememberValue) async {
    try {
      await AadAuthentication.getEnv();
      await AadAuthentication.oauth!.logout();
      await AadAuthentication.oauth!.login();
      String? accessToken = await AadAuthentication.oauth!.getAccessToken();
      if (accessToken!.isNotEmpty) {
        var microsoftResponse =
            await Data.getUserData({"accesstoken": accessToken});
        Map<String, dynamic> mircosoftJsonObject =
            jsonDecode(microsoftResponse!.body);
        var apiUserResponse = await Data.check(
            Data.checkUserRegistered, {"email": mircosoftJsonObject["mail"]});
        var isRegistered;
        if (apiUserResponse.statusCode != 200 ||
            jsonDecode(apiUserResponse.body)["email"].toString().isEmpty) {
          isRegistered = false;
        } else {
          isRegistered = true;
        }
        //TODO new veriosn of api
        if (isRegistered) //api get// see if user is registered
        {
          //@TODO 1. Session User bei jeder Anmeldung Speichern sobald successFul
          //2. Bei main.dart wenn im usersecureStoraghe rememberMe auf true ist werte direkt in session info holen
          //Bei main.Dart falls rememberMe auf Falls ist UserSecureStorage entleeren
          //ebenfalls bei getriegerten logout machen
          SessionUser.fromJson(
              jsonDecode(apiUserResponse.body), mircosoftJsonObject);
          if (rememberValue) {
            UserSecureStorage.setUserValues(
                jsonDecode(apiUserResponse.body), mircosoftJsonObject);
          }
          return const Tuple2(LoginStatusType.ALREADYLOGGEDIN, "");
        } else {
          return Tuple2(LoginStatusType.NEWLOGIN, microsoftResponse.body);
        }
      }
      UserSecureStorage.setRememberState("false");
    } catch (e) {
      return const Tuple2(LoginStatusType.ERROR, "");
    }
    return null;
  }
}
