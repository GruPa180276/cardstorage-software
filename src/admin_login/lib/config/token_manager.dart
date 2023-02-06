import 'package:admin_login/provider/types/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();
  static late String auth;

  static void setToken() async {
    await authAdminLogin("card_storage_admin@default.com")
        .then((value) => auth = value);
    storage.write(key: "jwt", value: auth);
  }

  static Future<String?> getToken() async {
    String? token = await storage.read(key: "jwt");
    return token;
  }
}
