import 'package:rfidapp/provider/types/user.dart';

class Reservation {
  // "since": 1673000473,
  // 					"until": -62135596800,
  // 					"returned-at": -62135596800,
  // 					"id": 1,
  // 					"user": {
  // 						"reader": "",
  // 						"email": "",
  // 						"privileged": false
  // 					},
  // 					"is-reservation": false

//final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
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
