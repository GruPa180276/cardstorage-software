import 'package:rfidapp/provider/types/cards-status.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:rfidapp/provider/types/storage.dart';

class ApiParser{
    static void combineCardDatas(List<Cards> cards, List<CardsStatus> cardsStatus,List<Storage> storages) {
      for (var card in cards) {

        cardsStatus.forEach((element) {
          if(element.cardid==card.id){
            card.isAvailable=element.isCardAvailable;
          }
          });
        storages.forEach((element) {
          if(card.storageid==element.id){
            card.storage=element.name;
          }
        });
      }

    }
}