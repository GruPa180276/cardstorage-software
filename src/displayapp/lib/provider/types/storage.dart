class Storage {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  int? id;
  int? locationid;
  String? name;
  String? ipaddress;
  int? capacity;

  @override
  Storage({
    required this.id,
    this.locationid,
    this.name,
    this.ipaddress,
    this.capacity,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "id": id,
      "locationid": locationid,
      "name": name,
      "ipaddress": ipaddress,
      "capacity": capacity,
    });
    return jsonTest;
  }

  static Storage fromJson(json) => Storage(
        id: json['id'],
        locationid: json['locationid'],
        name: json['name'],
        ipaddress: json['ipaddress'],
        capacity: json['capacity'],
      );
}
