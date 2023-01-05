class ReaderCards {
  //final DateTime? standardTime = DateTime(2000).microsecondsSinceEpoch;
  String reader;
  String name;
  int position;
  int accessed;
  bool available;

  @override
  ReaderCards({
    required this.reader,
    required this.name,
    required this.position,
    required this.accessed,
    required this.available,
  });

  ReaderCards.fromJson(Map<String, dynamic> json)
      :reader= json['reader'],
        name= json['name'],
        position= json['position'],
        accessed= json['accessed'],
        available= json['available'];
        
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "reader": reader,
      "name": name,
      "position": position,
      "accessed":accessed,
      "available": available,
    });

    return jsonTest;
  }


      
}
