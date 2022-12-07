class CardsStatus {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  final int id;
  int? cardid;
  int? reservationid;
  bool? isCardAvailable;
  int? reservationsTotal;

  @override
  CardsStatus({
    required this.id,
    this.cardid,
    this.reservationid,
    this.isCardAvailable,
    this.reservationsTotal,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "id": id,
      "cardid": cardid,
      "reservationid": reservationid,
      "isCardAvailable": isCardAvailable,
      "reservationsTotal": reservationsTotal,
    });

    return jsonTest;
  }

  static CardsStatus fromJson(json) => CardsStatus(
        id: json['id'],
        cardid: json['cardid'],
        reservationid: json['reservationid'],
        isCardAvailable: json['isCardAvailable'],
        reservationsTotal: json['reservationsTotal'],
      );
}
