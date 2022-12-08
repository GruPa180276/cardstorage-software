import 'package:rfidapp/provider/types/cards-status.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class ApiParser {
  static void combineCardDatas(List<Cards> cards, List<CardsStatus> cardsStatus,
      List<Storage> storages) {
    for (var card in cards) {
      try {
        for (var element in cardsStatus) {
          if (element.cardid == card.id) {
            card.isAvailable = false;
          }
        }
        for (var element in storages) {
          if (card.storageid == element.id) {
            card.storage = element.name;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  static List<String> getNamesOfStorages(List<Storage> storages) {
    List<String> names= [];
    for (Storage storage in storages) {
      names.add(storage.name!);
    }
    return names;
  }
}
