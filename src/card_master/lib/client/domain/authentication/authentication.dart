import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:card_master/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:card_master/main.dart';

class AadAuthentication {
  static AadOAuth? oauth;

  static Future<void> getEnv() async {
    await dotenv.load(fileName: "assets/azure.env");
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
