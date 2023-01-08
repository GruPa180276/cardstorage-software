import 'package:rfidapp/provider/types/readercard.dart';

class Storage {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  String name;
  String location;
  String address;
  int capacity;
  List<ReaderCard> cards;

  @override
  Storage(
      {required this.name,
      required this.location,
      required this.address,
      required this.capacity,
      required this.cards});
  factory Storage.fromJson(dynamic json) {
    var cardsObjJson = json['cards'] as List;
    List<ReaderCard> cards =
        cardsObjJson.map((tagJson) => ReaderCard.fromJson(tagJson)).toList();
    return Storage(
        name: json["name"],
        location: json['location'],
        address: json['address'],
        capacity: json['capacity'],
        cards: cards);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "name": name,
      "location": location,
      "address": address,
      "capacity": capacity,
      "cards": cards
    });
    return jsonTest;
  }
}
