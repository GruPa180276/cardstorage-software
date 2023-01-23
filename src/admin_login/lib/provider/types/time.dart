import 'dart:convert';
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
  );
  if (response.statusCode == 200) {
    dynamic jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return ReservationTime.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to get Storages!');
  }
}

Future<ReservationTime> changeReservationLatestGetTime(double time) async {
  final http.Response response = await http.put(
    Uri.parse(adres.reservationAdress + "/time/hours/" + time.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return ReservationTime.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Storage!');
  }
}
