import 'dart:convert';
import 'package:http/http.dart' as http;

class Storages {
  int id;
  String name;
  String ipAdress;
  int numberOfCards;
  String location;

  Storages({
    required this.id,
    required this.name,
    required this.ipAdress,
    required this.numberOfCards,
    required this.location,
  });

  factory Storages.fromJson(Map<String, dynamic> json) {
    return Storages(
        id: json['id'],
        name: json['name'],
        ipAdress: json['ipAdress'],
        numberOfCards: json['numberOfCards'],
        location: json['location']);
  }
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
        'ipAdress': ipAdress.toString(),
        'numberOfCards': numberOfCards.toString(),
        'location': location,
      };
}

Future<List<Storages>> fetchData() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:7171/storage/'),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Storages.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<Storages> deleteData(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('http://10.0.2.2:7171/storage/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

Future<Storages> updateData(Map<String, dynamic> data) async {
  final http.Response response = await http.put(
    Uri.parse('http://10.0.2.2:7171/storage/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

Future<Storages> sendData(Map<String, dynamic> data) async {
  final http.Response response = await http.post(
    Uri.parse('http://10.0.2.2:7171/storage/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    return Storages.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
