import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyRememberState = 'state';
//user
  static const _keyUserFirstname = 'firtsname';
  static const _keyUserLastname = 'lastename';
  static const _keyUserEmail = 'email';
  static const _keyUserOfficelocation = 'officelocation';

  static Future setRememberState(String state) async =>
      await _storage.write(key: _keyRememberState, value: state);

  static Future<String?> getRememberState() async =>
      await _storage.read(key: _keyRememberState);
  //user data

  static void setUserValues(
      String lastname, String firstname, String email, String officelocation) {
    UserSecureStorage.setUserLastname(lastname.toString());
    UserSecureStorage.setUserFirstname(firstname.toString());
    UserSecureStorage.setUserEmail(email.toString());
    UserSecureStorage.setUserOfficeLocation(officelocation.toString());
  }

  static Future<Map<String, String>> getUserValues() async {
    var userEmail = await UserSecureStorage.getUserEmail();
    var userFirstname = await UserSecureStorage.getUserFirstname();
    var userLastname = await UserSecureStorage.getUserLastname();
    var userOfficeLocation = await UserSecureStorage.getUserOfficeLocatione();
    return Map.of({
      "Email": userEmail!,
      "Firstname": userFirstname!,
      "Lastname": userLastname!,
      "OfficeLocation": userOfficeLocation!
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
}
