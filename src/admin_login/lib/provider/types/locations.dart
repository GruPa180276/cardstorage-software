import 'dart:convert';
import 'package:http/http.dart' as http;

String ipadress = "http://192.168.120.186:7171/api/locations";

class Locations {
  int id;
  String location;

  Locations({
    required this.id,
    required this.location,
  });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      id: json['id'] ?? 0,
      location: json['location'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
      };
}

Future<List<Locations>> fetchData() async {
  final response = await http.get(
    Uri.parse(ipadress),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Locations.fromJson(data)).toList();
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
    return Locations.fromJson(json.decode(response.body));
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
    return Locations.fromJson(json.decode(response.body));
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
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
