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
}

Future<List<Data>> fetchData() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:7171/card'),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<Data> deleteData(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('http://10.0.2.2:7171/card'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

Future<Data> updateData(
    String title, int id, String imgUrl, int quantity) async {
  final http.Response response = await http.put(
    Uri.parse('http://10.0.2.2:7171/card'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'id': id.toString(),
      'imgUrl': imgUrl,
      'quantity': quantity.toString()
    }),
  );

  if (response.statusCode == 200) {
    return Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to update album.');
  }
}

Future<Data> sendData(String title, int id, String imgUrl, int quantity) async {
  final http.Response response = await http.post(
    Uri.parse('http://10.0.2.2:7171/card'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'id': id.toString(),
      'imgUrl': imgUrl,
      'quantity': quantity.toString()
    }),
  );
  if (response.statusCode == 201) {
    return Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
