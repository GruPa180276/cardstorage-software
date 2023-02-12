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

class SessionUser {
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
    AadAuthentication.oauth!.logout();
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
    bool isRegistered;

    try {
      await AadAuthentication.getEnv();
      await AadAuthentication.oauth!.logout();
      await AadAuthentication.oauth!.login();
      String? accessToken = await AadAuthentication.oauth!.getAccessToken();
      if (accessToken!.isNotEmpty) {
        var microsoftResponse =
            await Data.getUserData({"accesstoken": accessToken});
        var mircosoftJsonObject = jsonDecode(microsoftResponse.body);
        var apiUserResponse = await Data.checkAuthorization(
            function: Data.getUserByName,
            args: {"email": mircosoftJsonObject["mail"]});
        var apiJsonObject = jsonDecode(apiUserResponse!.body);
        if (apiUserResponse.statusCode != 200 ||
            apiJsonObject["email"].toString().isEmpty) {
          isRegistered = false;
        } else {
          isRegistered = true;
        }
        if (isRegistered) //api get// see if user is registered
        {
          SessionUser.fromJson(apiJsonObject, mircosoftJsonObject);
          if (rememberValue) {
            UserSecureStorage.setUserValues(apiJsonObject, mircosoftJsonObject);
            UserSecureStorage.setRememberState(rememberValue.toString());
          }
          return const Tuple2(LoginStatusType.ALREADYLOGGEDIN, null);
        } else {
          return Tuple2(LoginStatusType.NEWLOGIN, mircosoftJsonObject);
        }
      }
      UserSecureStorage.setRememberState("false");
    } catch (e) {
      return Tuple2(LoginStatusType.ERROR, e.toString());
    }
    return null;
  }

  static Future<bool> signUp(BuildContext context, dynamic mircosoftJsonObject,
      bool rememberValue) async {
    await StorageSelectPopUp.build(context);
    if (StorageSelectPopUp.getSuccessful()) {
      var reqTimer = RequestTimer(
          context: context,
          action: TimerAction.SIGNUP,
          email: mircosoftJsonObject!["mail"],
          storagename: StorageSelectPopUp.getSelectedStorage());
      await reqTimer.startTimer();
      if (reqTimer.getSuccessful()) {
        //@TODO
        //MicrosoftUser.setUserValues(jsonDecode(loginStatus.item2!));
        SessionUser.fromJson(null, mircosoftJsonObject);
        if (rememberValue) {
          UserSecureStorage.setRememberState(rememberValue.toString());
          UserSecureStorage.setUserValues(null, mircosoftJsonObject);
        }
        return true;
      }
      return false;
    } else {
      return false;
    }
  }
}
