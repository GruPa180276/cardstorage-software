import 'package:card_master/admin/config/adress.dart';
import 'package:http/http.dart';

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

Future<Response> authAdminLogin(Map<String, dynamic> data) async {
  return await get(
    Uri.parse("$adress/api/v1/auth/user/email/${data["name"]}"),
    headers: <String, String>{
      'Content-Type': 'text/plain',
    },
  );
}
