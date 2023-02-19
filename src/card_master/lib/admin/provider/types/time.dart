import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/admin/config/token_manager.dart';

class ReservationTime {
  double time;
  String unit;

  ReservationTime({
    required this.time,
    required this.unit,
  });

  factory ReservationTime.fromJson(dynamic json) {
    return ReservationTime(
      time: json['time'] ?? 0,
      unit: json['unit'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'unit': time,
      };
}

Future<Response> getReservationLatestGetTime() async {
  return await get(
    Uri.parse(reservationAdress + "/time"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}

Future<Response> changeReservationLatestGetTime(
    Map<String, dynamic> data) async {
  return await put(
    Uri.parse(reservationAdress + "/time/hours/" + data["name"]),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Content-Type": "application/json"
    },
  );
}
