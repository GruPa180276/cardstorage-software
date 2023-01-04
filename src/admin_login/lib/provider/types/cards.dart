import 'dart:convert';
import 'package:http/http.dart' as http;

String ipadress = "http://192.168.120.186:7171/api/storages/cards";

class Cards {
  int id;
  String name;
  int storage;

  Cards({
    required this.id,
    required this.name,
    required this.storage,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      storage: json['storage-id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'storage': storage,
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
    throw Exception('Failed to get Cards!');
  }
}

Future<dynamic> deleteData(String name) async {
  final http.Response response = await http.delete(
    Uri.parse(ipadress + "/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete Card!');
  }
}

Future<dynamic> updateData(String name, Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse(ipadress + "/name/" + name),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Cards.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update Card!');
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
    throw Exception('Failed to add Card!');
  }
}
