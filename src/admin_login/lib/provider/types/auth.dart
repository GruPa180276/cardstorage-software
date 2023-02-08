import 'package:http/http.dart' as http;

class Auth {
  String token;

  Auth({
    required this.token,
  });

  factory Auth.fromJson(dynamic json) {
    return Auth(
      token: json,
    );
  }
}

Future<String> authAdminLogin(String mail) async {
  final response = await http.get(
    Uri.parse("https://10.0.2.2:7171/api/v1/auth/user/email/" + mail),
    headers: <String, String>{
      'Content-Type': 'text/plain',
    },
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get Token!');
  }
}
