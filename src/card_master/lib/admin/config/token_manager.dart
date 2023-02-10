import 'package:card_master/admin/provider/types/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:card_master/client/provider/session_user.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();
  static late String auth;

  static void setToken() async {
    await authAdminLogin(SessionUser.getEmail()!).then((value) => auth = value);
    storage.write(key: "jwt", value: auth);
  }

  static Future<String?> getToken() async {
    String? token = await storage.read(key: "jwt");
    return token;
  }
}
