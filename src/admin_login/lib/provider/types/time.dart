import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

class Reservations {
  int time;

  Reservations({
    required this.time,
  });

  factory Reservations.fromJson(dynamic json) {
    return Reservations(
      time: json ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': time,
      };
}

Future<Reservations> getReservationLatestGetTime() async {
  final response = await http.get(
    Uri.parse(adres.reservationAdress + "/time"),
  );
  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    return Reservations.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to get Storages!');
  }
}

Future<Reservations> changeReservationLatestGetTime(double time) async {
  final http.Response response = await http.put(
    Uri.parse(adres.reservationAdress + "/time/" + time.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Reservations.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Storage!');
  }
}
