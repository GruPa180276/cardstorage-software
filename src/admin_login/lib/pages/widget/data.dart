import 'dart:convert';
import 'package:http/http.dart' as http;

class Data {
  final int userId;
  final int id;
  final String title;

  Data({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['id'],
      id: json['id'],
      title: json['name'],
    );
  }

  Data fromJson(json) => Data(
        id: json['id'],
        userId: json['id'],
        title: json['name'],
      );
}

Future<List<Data>> fetchData() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:7171/card'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}
