import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_login/config/adress.dart' as adres;

class Users {
  String email;
  bool privileged;

  Users({
    required this.email,
    required this.privileged,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      email: json['email'] ?? "",
      privileged: json['privileged'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {
        'email': email,
        'privileged': privileged,
      };
}

Future<List<Users>> fetchData() async {
  final response = await http.get(
    Uri.parse(adres.usersAdress),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Users.fromJson(data)).toList();
  } else {
    throw Exception('Failed to get Storages!');
  }
}
