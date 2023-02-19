// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/authentication/authentication.dart';
import 'package:card_master/client/domain/persistent/user_secure_storage.dart';
import 'package:card_master/client/domain/types/login_status_type.dart';
import 'package:card_master/client/domain/types/timer_action_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/request_timer.dart';
import 'package:card_master/client/pages/login/storage_select.dart';
import 'package:card_master/client/provider/rest/data.dart';
import 'package:tuple/tuple.dart';

class UserSessionManager {
  static String? _email;
  static bool? _priviliged;
  static String? _userFirstname;
  static String? _userLastname;
  static String? _userOfficeLocation;

  static String? getEmail() {
    return _email;
  }

  static bool? getPrivileged() {
    return _priviliged;
  }

  static String? getUserFirstname() {
    return _userFirstname;
  }

  static String? getUserLastname() {
    return _userLastname;
  }

  static String? getUserOfficeLocation() {
    return _userOfficeLocation;
  }

  static fromJson(dynamic apiUser, dynamic microsoftUser) {
    _email = (microsoftUser == null) ? apiUser["email"] : microsoftUser["mail"];
    _priviliged = (apiUser == null) ? false : apiUser["privileged"];
    _userFirstname = (microsoftUser == null)
        ? apiUser["firstname"]
        : microsoftUser["givenName"];
    _userLastname = (microsoftUser == null)
        ? apiUser["lastname"]
        : microsoftUser["surname"];
    _userOfficeLocation = (microsoftUser == null)
        ? apiUser["officeLocation"]
        : microsoftUser["officeLocation"];
  }

  static Future<void> logout(BuildContext context) async {
    await AadAuthentication.getEnv();
    UserSecureStorage.deleteAll();
    AadAuthentication.getOAuth()!.logout();
    Navigator.pushReplacementNamed(context, "/login");
  }

  static Future<bool> reloadUserData() async {
    var response = await Data.checkAuthorization(
        function: Data.getUserByName, args: {"email": _email});
    if (response!.statusCode != 200) {
      return false;
    }
    var jsonUserObject = jsonDecode(response.body);
    _priviliged = jsonUserObject["privileged"];
    return true;
  }

  static Future<Tuple2<LoginStatusType, dynamic>?> login(
      bool rememberValue) async {
    try {
      // Get environment and log out of any existing sessions
      await AadAuthentication.getEnv();
      await AadAuthentication.getOAuth()!.logout();

      // Start new authentication session
      await AadAuthentication.getOAuth()!.login();
      String? accessToken =
          await AadAuthentication.getOAuth()!.getAccessToken();
      if (accessToken!.isEmpty) {
        return null; // Return null if authentication fails
      }

      // Retrieve user data from aad
      var microsoftResponse =
          await Data.getGraphUserData({"accesstoken": accessToken});
      var mircosoftJsonObject = jsonDecode(microsoftResponse.body);
      var email = mircosoftJsonObject["mail"];

      // Check if user is registered in our system
      var apiUserResponse = await Data.checkAuthorization(
          function: Data.getUserByName, args: {"email": email});
      var apiJsonObject = jsonDecode(apiUserResponse!.body);
      if (apiJsonObject["email"].toString().isEmpty) {
        // User is not registered, return new login status
        return Tuple2(LoginStatusType.NOTREGISTERED, mircosoftJsonObject);
      }

      // User is registered, store session data and return already logged in status
      UserSessionManager.fromJson(apiJsonObject, mircosoftJsonObject);
      if (rememberValue) {
        UserSecureStorage.setUserValues(apiJsonObject, mircosoftJsonObject);
        UserSecureStorage.setRememberState(rememberValue.toString());
      } else {
        UserSecureStorage.setRememberState("false");
      }
      return const Tuple2(LoginStatusType.REGISTERED, null);
    } catch (e) {
      // Handle errors and return specific error
      return Tuple2(LoginStatusType.ERROR, e.toString());
    }
  }

  /// Registriert einen Benutzer mit Microsoft-Kontodaten.
  static Future<bool> signUp(BuildContext context, dynamic microsoftJsonObject,
      bool rememberValue) async {
    try {
      // Popup-Fenster zum Auswählen des Speicherorts anzeigen
      await StorageSelectPopUp.build(context);

      // Überprüfen, ob das Popup-Fenster erfolgreich war
      if (!StorageSelectPopUp.getSuccessful()) {
        return false;
      }
      // Timer starten, um die Anforderungsdauer zu messen
      var reqTimer = RequestTimer(
        context: context,
        action: TimerAction.SIGNUP,
        email: microsoftJsonObject!["mail"],
        storagename: StorageSelectPopUp.getSelectedStorage(),
      );
      await reqTimer.startTimer();

      // Überprüfen, ob der Timer erfolgreich war
      if (!reqTimer.getSuccessful()) {
        return false;
      }
      // Benutzerwerte setzen und speichern
      UserSessionManager.fromJson(null, microsoftJsonObject);
      if (rememberValue) {
        UserSecureStorage.setRememberState(rememberValue.toString());
        UserSecureStorage.setUserValues(null, microsoftJsonObject);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
