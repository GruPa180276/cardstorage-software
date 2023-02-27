import 'dart:io';
import 'package:http/http.dart';
import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/admin/config/token_manager.dart';
import 'package:card_master/admin/provider/types/reservations.dart';

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
    List<ReservationOfCards> reservations = tagObjsJson
        .map((tagJson) => ReservationOfCards.fromJson(tagJson))
        .toList();

    return CardReservation(
      name: json['name'] ?? "",
      storage: json['storage'] ?? "",
      position: json['position'] ?? 0,
      accessed: json['accessed'] ?? 0,
      available: json['available'] ?? false,
      reservation: reservations,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'storage': storage,
      };
}

Future<Response> fetchReservations() async {
  return await get(
    Uri.parse(cardAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
}
