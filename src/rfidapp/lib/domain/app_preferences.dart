import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _preferences;
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setIsOn(bool x) async => await _preferences.setBool('theme', x);
  static bool getIsOn() => _preferences.getBool('theme') ?? true;

  static Future addCardPinned(String id) async {
    Set<String> currentPins = getCardsPinned().toSet();
    currentPins.add(id);
    await _preferences.setStringList('pinnedCard', currentPins.toList());
  }

  static void removePinnedCardAt(int id) {
    Set<String>? currentPins = getCardsPinned();

    currentPins.removeWhere((element) => element == id.toString());
    //currentPins.indexOf(id.toString())
    overritePinnedCard(currentPins);
  }

  static Future overritePinnedCard(Set<String> pinnedCard) async =>
      await _preferences.setStringList('pinnedCard', pinnedCard.toList());

  static Set<String> getCardsPinned() =>
      _preferences.getStringList('pinnedCard')?.toSet() ?? <String>{"s"};
}
