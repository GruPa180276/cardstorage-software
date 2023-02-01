import 'dart:convert';
import 'package:rfidapp/domain/authentication/authentication.dart';
import 'package:rfidapp/domain/authentication/user_secure_storage.dart';
import 'package:rfidapp/domain/enums/login_status_type.dart';
import 'package:rfidapp/provider/connection/api/data.dart';
import 'package:rfidapp/provider/types/microsoft_user.dart';
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
        var userResponse = await Data.getUserData(accessToken);
        var email = jsonDecode(userResponse!.body)["mail"];
        bool registered = await Data.checkUserRegistered(email);
        if (registered) //api get// see if user is registered
        {
          MicrosoftUser.setUserValues(jsonDecode(userResponse.body));
          UserSecureStorage.setRememberState(rememberValue.toString());
          return const Tuple2(LoginStatusType.ALREADYLOGGEDIN, "");
        } else {
          return Tuple2(LoginStatusType.NEWLOGIN, userResponse.body);
        }
      }
      UserSecureStorage.setRememberState("false");
    } catch (e) {
      return const Tuple2(LoginStatusType.ERROR, "");
    }
    return null;
  }
}
