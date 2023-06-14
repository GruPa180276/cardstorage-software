import 'package:card_master/client/provider/rest/types/readercard.dart';
import 'package:card_master/client/provider/rest/types/storage.dart';

class Utils {
  static List<ReaderCard> parseToReaderCards(List<Storage> storages) {
    List<ReaderCard> readercards = List.empty(growable: true);
    for (var storage in storages) {
      for (var card in storage.cards) {
        card.storageName = storage.name;
        card.location = storage.location;
        readercards.add(card);
      }
    }
    return readercards;
  }
}
