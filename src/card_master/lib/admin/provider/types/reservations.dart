import 'dart:convert';
import 'dart:io';
import 'package:card_master/admin/config/token_manager.dart';
import 'package:card_master/admin/provider/types/user.dart';
import 'package:http/http.dart' as http;
import 'package:card_master/admin/config/adress.dart' as adres;

class ReservationOfCards {
  int id;
  int since;
  int until;
  int returnedAt;
  bool isReservation;
  Users users;

  ReservationOfCards({
    required this.id,
    required this.since,
    required this.until,
    required this.returnedAt,
    required this.isReservation,
    required this.users,
  });

  factory ReservationOfCards.fromJson(Map<String, dynamic> json) {
    Users _users = Users.fromJson(json['user']);

    return ReservationOfCards(
        id: json['id'] ?? 0,
        since: json['since'] ?? 0,
        until: json['until'] ?? 0,
        returnedAt: json['returned-at'] ?? 0,
        isReservation: json['is-reservation'] ?? false,
        users: _users);
  }
}

Future<List<ReservationOfCards>> fetchData() async {
  final response = await http.get(
    Uri.parse(adres.reservationAdress),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => ReservationOfCards.fromJson(data))
        .toList();
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return fetchData();
  } else {
    throw Exception('Failed to get Reservations!');
  }
}

Future<int> deleteReservation(int id) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.reservationAdress + "/id/" + id.toString()),
    headers: {
      HttpHeaders.authorizationHeader:
          "Bearer ${await SecureStorage.getToken()}",
      "Accept": "application/json"
    },
  );
  if (response.statusCode == 200) {
    return response.statusCode;
  } else if (response.statusCode == 400) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    await Future.delayed(Duration(seconds: 1));
    SecureStorage.setToken();
    return deleteReservation(id);
  } else {
    throw Exception('Failed to delete Reservation!');
  }
}
