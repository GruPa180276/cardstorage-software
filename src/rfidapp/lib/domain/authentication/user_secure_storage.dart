import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyRememberState = 'state';
//user
  static const _keyUserFirstname = 'firtsname';
  static const _keyUserLastname = 'lastename';
  static const _keyUserEmail = 'email';
  static const _keyUserOfficelocation = 'officelocation';
  static const _keyPriviledged = 'officelocation';

  static Future setRememberState(String state) async =>
      await _storage.write(key: _keyRememberState, value: state);

  static Future<String?> getRememberState() async =>
      await _storage.read(key: _keyRememberState);
  //user data

  static void setUserValues(dynamic user) {
    UserSecureStorage.setUserLastname(user[1]["givenName"]).toString();
    UserSecureStorage.setUserFirstname(user[1]["surname"].toString());
    UserSecureStorage.setUserEmail(user[1]["mail"].toString());
    UserSecureStorage.setUserOfficeLocation(
        user[1]["officeLocation"].toString());
    UserSecureStorage.setPrivileged(user[0]["priviledged"].toString());
  }

  static Future<Map<String, String>> getUserValues() async {
    var userEmail = await UserSecureStorage.getUserEmail();
    var userFirstname = await UserSecureStorage.getUserFirstname();
    var userLastname = await UserSecureStorage.getUserLastname();
    var userOfficeLocation = await UserSecureStorage.getUserOfficeLocatione();
    var privileged = await UserSecureStorage.getUserOfficeLocatione();

    return Map.of({
      "Email": userEmail!,
      "Firstname": userFirstname!,
      "Lastname": userLastname!,
      "OfficeLocation": userOfficeLocation!,
      "Privileged": privileged!
    });
  }

  static Future setUserLastname(String value) async =>
      await _storage.write(key: _keyUserLastname, value: value);

  static Future<String?> getUserLastname() async =>
      await _storage.read(key: _keyUserLastname);

  static Future setUserFirstname(String value) async =>
      await _storage.write(key: _keyUserFirstname, value: value);

  static Future<String?> getUserFirstname() async =>
      await _storage.read(key: _keyUserFirstname);

  static Future setUserEmail(String value) async =>
      await _storage.write(key: _keyUserEmail, value: value);

  static Future<String?> getUserEmail() async =>
      await _storage.read(key: _keyUserEmail);

  static Future setUserOfficeLocation(String value) async =>
      await _storage.write(key: _keyUserOfficelocation, value: value);

  static Future<String?> getUserOfficeLocatione() async =>
      await _storage.read(key: _keyUserOfficelocation);

  static Future setPrivileged(String value) async =>
      await _storage.write(key: _keyPriviledged, value: value);

  static Future<String?> getPrivileged() async =>
      await _storage.read(key: _keyPriviledged);
}
