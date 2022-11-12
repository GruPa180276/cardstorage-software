import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:rfidapp/main.dart';

class AadAuthentication {
  static late AadOAuth oauth;

  static void getEnv() async {
    await dotenv.load(fileName: "assets/.env");
    oauth = AadOAuth(config);
  }

  static final Config config = Config(
    tenant: dotenv.env['tenant']!,
    clientId: dotenv.env['clientId']!,
    scope: 'User.Read',
    redirectUri: 'cardstorage://auth',
    navigatorKey: MyApp.navigatorKey,
  );
}
