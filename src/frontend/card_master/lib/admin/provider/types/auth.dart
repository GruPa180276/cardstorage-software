import 'package:card_master/admin/config/adress.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';
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
    Uri.parse(
        "$adress/api/v1/auth/user/email/${UserSessionManager.getEmail()}"),
    headers: <String, String>{
      'Content-Type': 'text/plain',
    },
  );
}
