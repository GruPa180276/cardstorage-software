import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';

import 'package:card_master/client/provider/session_user.dart';

class Data {
  static String? bearerToken;
  static String uriRaspi = 'https://10.0.2.2:7171/api/v1/';

  static Future<Response> check(
      Function function, Map<String, dynamic>? args) async {
    Response response;
    if (bearerToken == null) {
      await _generateToken();
    }
    if (args != null) {
      response = await function(args);
    } else {
      response = await function();
    }
    if (response.statusCode == 401) {
      await _generateToken();

      if (args != null) {
        response = await function(args);
      } else {
        response = await function();
      }
    }
    return response;
  }

  static Future<Response?> getReaderCards() async {
    try {
      return await get(Uri.parse("${uriRaspi}storages"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Response?> getUserByName(Map<String, dynamic> args) async {
    return await get(Uri.parse("${uriRaspi}users/email/${args["email"]}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response?> getUserData(Map<String, String> args) async {
    return await get(Uri.parse("https://graph.microsoft.com/v1.0/me"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${args["accesstoken"]}",
          "Accept": "application/json"
        });
  }

  static Future<Response?> getAllReservationUser() async {
    return await get(
        Uri.parse(
            "${uriRaspi}storages/cards/reservations/details/user/email/${SessionUser.getEmail()}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          "Accept": "application/json"
        });
  }

  static Future<Response> postCreateNewUser(Map<String, dynamic> args) async {
    return post(Uri.parse('${uriRaspi}users'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        },
        body: jsonEncode(
            {"email": args["email"], "storage": args["storagename"]}));
  }

  static Future<Response> postGetCardNow(Map<String, dynamic> args) async {
    return put(
        Uri.parse(
            '${uriRaspi}storages/cards/name/${args["cardname"]}/fetch/user/email/${SessionUser.getEmail()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response?> getReservationsOfCard(
      Map<String, dynamic> args) async {
    //https: //localhost:7171/api/storages/cards/reservations/card/Card1
    return await get(
        Uri.parse(
            "${uriRaspi}storages/cards/reservations/card/${args["cardname"]}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response> newReservation(Map<String, dynamic> args) async {
    //		"/api/users/reservations/email/USER@PROVIDER.COM"
    return await post(
        Uri.parse(
            "${uriRaspi}users/reservations/email/${SessionUser.getEmail()}"),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        },
        body: jsonEncode({
          "card": args["cardname"],
          "since": args["since"],
          "until": args["until"],
          "is-reservation": true
        }));
    ;
  }

  static Future<Response> deleteReservation(Map<String, dynamic> args) async {
    var reservationResponse = await delete(
      Uri.parse(
          "${uriRaspi}storages/cards/reservations/id/${args["reservationid"]}"),
      headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      },
    );

    return reservationResponse;
  }

  static Future<void> _generateToken() async {
    var response = await get(
        Uri.parse(
            "${uriRaspi}auth${(SessionUser.getEmail() == null) ? "" : "/user/email/${SessionUser.getEmail()}"}"),
        headers: {
          "Content-Type": "text/plain",
        });
    bearerToken = response.body;
  }

  static void setToken(String token) async {
    // https://localhost:7171/api/auth/user/email/card_storage_admin@default.com
  }
}
