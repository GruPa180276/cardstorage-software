import 'package:card_master/client/provider/rest/types/user.dart';

class Reservation {
  int since;
  int until;
  int returndate;
  int id;
  User user;
  bool isreservation;
  String? cardName;
  String? storageName;

  @override
  Reservation(
      {required this.since,
      required this.until,
      required this.returndate,
      required this.id,
      required this.user,
      required this.isreservation,
      this.cardName,
      this.storageName});

  factory Reservation.fromJson(dynamic json) {
    if (json["cardName"] == null) {
      User user = User.fromJson(json["user"]);

      return Reservation(
          id: json["id"],
          isreservation: json["is-reservation"],
          returndate: json["returned-at"],
          since: json["since"],
          until: json["until"],
          user: user);
    }
    User user = User.fromJson(json["reservation"]["user"]);
    return Reservation(
        id: json["reservation"]["id"],
        isreservation: json["reservation"]["is-reservation"],
        returndate: json["reservation"]["returned-at"],
        since: json["reservation"]["since"],
        until: json["reservation"]["until"],
        user: user,
        cardName: json["cardName"],
        storageName: json["storageName"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "since": since,
      "until": until,
      "returndate": returndate,
      "id": id,
      "user": user,
      "isreservation": isreservation
    });
    return jsonTest;
  }
}
