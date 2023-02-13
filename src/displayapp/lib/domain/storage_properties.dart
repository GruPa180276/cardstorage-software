import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageProperties {
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: "assets/.env");
  }

  static String getStorageName() {
    return dotenv.env['STORAGE']!;
  }

  static String getLocation() {
    return dotenv.env['LOCATION']!;
  }

  static String getServer() {
    return dotenv.env['SERVER']!;
  }

  static String getRestPort() {
    return dotenv.env['REST_PORT']!;
  }

  static String getStorageUser() {
    return dotenv.env['STORAGEUSER']!;
  }
}
