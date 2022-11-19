import 'dart:convert';
import 'package:http/http.dart' as http;

class Storage {
  final int id;

  Storage({required this.id});

  factory Storage.fromJson(Map<String, dynamic> json) {
    return Storage(
      id: json['id'],
    );
  }
}

Future<List<Storage>> fetchData() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:7171/card'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Storage.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}
