class Cards {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  final int id;
  String? name;
  int? storageId;
  bool? isAvailable;
  bool? isReserved;
  int? reservedSince;
  int? reservedUntil;

  @override
  Cards(
      {required this.id,
      this.name,
      this.storageId,
      this.isAvailable,
      this.isReserved,
      this.reservedSince,
      this.reservedUntil});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "id": id,
      "name": name ?? "",
      "storageId": storageId ?? 0,
      "isAvailable": isAvailable ?? false,
      "isReserved": isReserved ?? false,
      "reservedSince": reservedSince ?? -62135596800,
      "reservedUntil": reservedUntil ?? -62135596800
    });

    return jsonTest;
  }

  static Cards fromJson(json) => Cards(
        id: json['id'],
        name: json['name'],
        storageId: json['storageId'],
        isAvailable: json['isAvailable'],
      );
}
