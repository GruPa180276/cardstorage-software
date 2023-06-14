import 'package:card_master/client/provider/rest/types/reservation.dart';

class ReaderCard {
  String reader;
  String name;
  int position;
  int accessed;
  bool available;
  List<Reservation>? reservation;
  String? storageName;
  String? location;

  @override
  ReaderCard(
      {required this.reader,
      required this.name,
      required this.position,
      required this.accessed,
      required this.available,
      this.reservation});

  factory ReaderCard.fromJson(Map<String, dynamic> json) {
    if (json["reservations"] != null) {
      var cardsObjJson = json['reservations'] as List;
      List<Reservation> cards =
          cardsObjJson.map((tagJson) => Reservation.fromJson(tagJson)).toList();
      return ReaderCard(
          reader: json['reader'],
          name: json['name'],
          position: json['position'],
          accessed: json['accessed'],
          available: json['available'],
          reservation: cards);
    }
    return ReaderCard(
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
