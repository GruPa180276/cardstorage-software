import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageProperties {
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: "assets/.env");
  }

  static String getServer() {
    return dotenv.env['SERVER']!;
  }

  static String getRestPort() {
    return dotenv.env['REST_PORT']!;
  }
}
