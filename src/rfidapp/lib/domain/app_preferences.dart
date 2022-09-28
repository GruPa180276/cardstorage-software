import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _preferences;
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setIsOn(bool x) async => await _preferences.setBool('theme', x);
  static bool getIsOn() => _preferences.getBool('theme') ?? true;

  static Future addCardPinned(String id) async {
    List<String> currentPins =
        _preferences.getStringList('pinnedCard') ?? <String>[id];
    if (currentPins.length > 1) {
      currentPins.add(id);
    }
    await _preferences.setStringList('pinnedCard', currentPins);
  }

  static void removePinnedCardAt(int id) {
    List<String>? currentPins = _preferences.getStringList('pinnedCard');
    currentPins!.removeAt(currentPins.indexOf(id.toString()));
    overritePinnedCard(currentPins);
  }

  static Future overritePinnedCard(List<String> pinnedCard) async =>
      await _preferences.setStringList('pinnedCard', pinnedCard);

  static List<String> getCardsPinned() =>
      _preferences.getStringList('pinnedCard') ?? List.empty();
}
