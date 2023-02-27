import 'dart:io';

import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/config/token_manager.dart';

class ReservationOfCards {
  int id;
  String name;
  int since;
  int until;
  int returnedAt;
  bool isReservation;
  Users users;

  ReservationOfCards({
    required this.id,
    required this.name,
    required this.since,
    required this.until,
    required this.returnedAt,
    required this.isReservation,
    required this.users,
  });

  factory ReservationOfCards.fromJson(Map<String, dynamic> json) {
    Users users = Users.fromJson(json['user']);

    return ReservationOfCards(
        id: json['id'] ?? 0,
        name: "",
        since: json['since'] ?? 0,
        until: json['until'] ?? 0,
        returnedAt: json['returned-at'] ?? 0,
        isReservation: json['is-reservation'] ?? false,
        users: users);
  }
}

Future<Response> fetchRservations() async {
  return await get(
    Uri.parse(reservationAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> deleteReservation(Map<String, dynamic> data) async {
  return await delete(
    Uri.parse("$reservationAdress/id/${data["name"]}"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}
