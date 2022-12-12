import 'dart:convert';
import 'package:http/http.dart' as http;

String ipadress = "http://192.168.120.186:7171/api/cards";

class Cards {
  int id;
  String name;
  int storageid;

  Cards({
    required this.id,
    required this.name,
    required this.storageid,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      storageid: json['storage-id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'storage-id': storageid,
      };
}

Future<List<Cards>> fetchData() async {
  final response = await http.get(
    Uri.parse(ipadress),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Cards.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<dynamic> deleteData(int id) async {
  final http.Response response = await http.delete(
    Uri.parse(ipadress),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

Future<dynamic> updateData(Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(ipadress),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

Future<dynamic> sendData(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse(ipadress),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
