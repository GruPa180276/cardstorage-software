import 'package:rfidapp/provider/types/user.dart';

class Reservation {
  int since;
  int until;
  int returndate;
  int id;
  User user;
  bool isreservation;
  String? cardName;

  @override
  Reservation(
      {required this.since,
      required this.until,
      required this.returndate,
      required this.id,
      required this.user,
      required this.isreservation});

  factory Reservation.fromJson(dynamic json) {
    User user = User.fromJson(json["user"]);
    print("here");
    return Reservation(
        id: json["id"],
        isreservation: json["is-reservation"],
        returndate: json["returned-at"],
        since: json["since"],
        until: json["until"],
        user: user);
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
