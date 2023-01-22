import 'dart:convert';
import 'package:admin_login/provider/types/user.dart';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

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
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => ReservationOfCards.fromJson(data))
        .toList();
  } else {
    throw Exception('Failed to get Storages!');
  }
}

Future<ReservationOfCards> deleteReservation(int id) async {
  final http.Response response = await http.delete(
    Uri.parse(adres.reservationAdress + "/id/" + id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return ReservationOfCards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Storage!');
  }
}
