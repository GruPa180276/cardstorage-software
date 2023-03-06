// ignore_for_file: constant_identifier_names

class ServerProperties {
  static const SERVER = '10.0.2.2';
  static const REST_PORT = 7171;
  static const MS_GRAPH = 'https://graph.microsoft.com/v1.0/me';
  static const BASE_URI = '/api/v1/';

  static Future<void> loadEnv() async {
    //await dotenv.load(fileName: "assets/.env");
  }

  static String getServer() {
    return SERVER;
  }

  static String getBaseUri() {
    return BASE_URI;
  }

  static String getMsGraphAdress() {
    return MS_GRAPH;
  }

  static String getRestPort() {
    return REST_PORT.toString();
  }
}
