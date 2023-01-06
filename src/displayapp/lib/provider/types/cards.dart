import 'package:rfidapp/provider/types/reservation.dart';

class ReaderCards {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  String reader;
  String name;
  int position;
  int accessed;
  bool available;
  List<Reservation>? reservation;

  @override
  ReaderCards(
      {required this.reader,
      required this.name,
      required this.position,
      required this.accessed,
      required this.available,
      this.reservation});

  factory ReaderCards.fromJson(Map<String, dynamic> json) {
    if (json["reservations"] != null) {
      print(json['name']);
      var cardsObjJson = json['reservations'] as List;
      List<Reservation> cards =
          cardsObjJson.map((tagJson) => Reservation.fromJson(tagJson)).toList();
      return ReaderCards(
          reader: json['reader'],
          name: json['name'],
          position: json['position'],
          accessed: json['accessed'],
          available: json['available'],
          reservation: cards);
    }
    return ReaderCards(
        reader: json['reader'],
        name: json['name'],
        position: json['position'],
        accessed: json['accessed'],
        available: json['available']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "reader": reader,
      "name": name,
      "position": position,
      "accessed": accessed,
      "available": available,
    });
    return jsonTest;
  }
}
