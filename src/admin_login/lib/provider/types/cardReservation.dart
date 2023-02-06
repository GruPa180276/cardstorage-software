import 'dart:convert';
import 'dart:io';
import 'package:admin_login/config/token_manager.dart';
import 'package:admin_login/provider/types/reservations.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

class CardReservation {
  String name;
  String storage;
  int position;
  int accessed;
  bool available;
  List<ReservationOfCards> reservation;

  CardReservation({
    required this.name,
    required this.storage,
    required this.position,
    required this.accessed,
    required this.available,
    required this.reservation,
  });

  factory CardReservation.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['reservations'] as List;
    List<ReservationOfCards> _reservations = tagObjsJson
        .map((tagJson) => ReservationOfCards.fromJson(tagJson))
        .toList();

    return CardReservation(
      name: json['name'] ?? "",
      storage: json['storage'] ?? "",
      position: json['position'] ?? 0,
      accessed: json['accessed'] ?? 0,
      available: json['available'] ?? false,
      reservation: _reservations,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'storage': storage,
      };
}

Future<List<CardReservation>> fetchData() async {
  final response = await http.get(
    Uri.parse(adres.cardAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => CardReservation.fromJson(data)).toList();
  } else {
    throw Exception('Failed to get Card Reservation!');
  }
}

Future<CardReservation> deleteData(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.cardAdress + "/name/" + name),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return CardReservation.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Card Reservation!');
  }
}
