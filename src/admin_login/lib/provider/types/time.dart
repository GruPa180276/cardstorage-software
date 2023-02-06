import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

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

Future<ReservationTime> getReservationLatestGetTime() async {
  final response = await http.get(
    Uri.parse(adres.reservationAdress + "/time"),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return ReservationTime.fromJson(jsonResponse);
  } else if (response.statusCode == 401) {
    SecureStorage.setToken();
    return getReservationLatestGetTime();
  } else {
    throw Exception('Failed to get Time!');
  }
}

Future<ReservationTime> changeReservationLatestGetTime(double time) async {
  final http.Response response = await http.put(
    Uri.parse(adres.reservationAdress + "/time/hours/" + time.toString()),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return ReservationTime.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    SecureStorage.setToken();
    return changeReservationLatestGetTime(time);
  } else {
    throw Exception('Failed to change Time!');
  }
}
