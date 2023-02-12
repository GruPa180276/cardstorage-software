// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/response_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:async';

import 'package:card_master/client/domain/authentication/session_user.dart';

import '../../config/properties/server_properties.dart';

class Data {
  static String? bearerToken;
  static String apiAdress =
      'https://${ServerProperties.getServer()}:${ServerProperties.getRestPort()}${ServerProperties.getBaseUri()}';

  static Future<Response?> checkAuthorization(
      {BuildContext? context,
      required Function function,
      Map<String, dynamic>? args}) async {
    try {
      Response response;
      if (bearerToken == null) {
        await _generateToken();
      }
      response = (args != null) ? await function(args) : await function();

      if (response.statusCode == 401) {
        await _generateToken();
        response = (args != null) ? await function(args) : await function();
      }
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      return response;
    } catch (e) {
      if (context != null) {
        SnackbarBuilder(
                context: context,
                header: "Error",
                snackbarType: SnackbarType.failure,
                content: e.toString())
            .build();
      }
    }
  }

  static Future<Response> getReaderCards() async {
    return await get(Uri.parse("${apiAdress}storages"), headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
    });
  }

  static Future<Response> getUserByName(Map<String, dynamic> args) async {
    return await get(Uri.parse("${apiAdress}users/email/${args["email"]}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response> getUserData(Map<String, String> args) async {
    return await get(Uri.parse(ServerProperties.getMsGraphAdress()), headers: {
      HttpHeaders.authorizationHeader: "Bearer ${args["accesstoken"]}",
      "Accept": "application/json"
    });
  }

  static Future<Response> getAllReservationUser() async {
    return await get(
        Uri.parse(
            "${apiAdress}storages/cards/reservations/details/user/email/${SessionUser.getEmail()}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          "Accept": "application/json"
        });
  }

  static Future<Response> postCreateNewUser(Map<String, dynamic> args) async {
    return post(Uri.parse('${apiAdress}users'),
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
            '${apiAdress}storages/cards/name/${args["cardname"]}/fetch/user/email/${SessionUser.getEmail()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response?> getReservationsOfCard(
      Map<String, dynamic> args) async {
    return await get(
        Uri.parse(
            "${apiAdress}storages/cards/reservations/card/${args["cardname"]}"),
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $bearerToken",
        });
  }

  static Future<Response> newReservation(Map<String, dynamic> args) async {
    //		"/api/users/reservations/email/USER@PROVIDER.COM"
    return await post(
        Uri.parse(
            "${apiAdress}users/reservations/email/${SessionUser.getEmail()}"),
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
          "${apiAdress}storages/cards/reservations/id/${args["reservationid"]}"),
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
            "${apiAdress}auth${(SessionUser.getEmail() == null) ? "" : "/user/email/${SessionUser.getEmail()}"}"),
        headers: {
          "Content-Type": "text/plain",
        });
    bearerToken = response.body;
  }

  static String getBearerToken() {
    return bearerToken!;
  }
}
