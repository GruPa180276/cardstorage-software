class Cards {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  String? readerdata;
  final int? id;
  int? storageid;
  String? name;
  int? position;
  bool? isAvailable;
  String? storage;

  @override
  Cards({
    required this.id,
    this.readerdata,
    this.storageid,
    this.name,
    this.position,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "id": id,
      "readerdata": readerdata,
      "storageid": storageid,
      "name": name,
      "position": position,
    });

    return jsonTest;
  }

  static Cards fromJson(json) => Cards(
        id: json['id'],
        readerdata: json['readerdata'],
        storageid: json['storageid'],
        name: json['name'],
        position: json['position'],
      );
}
