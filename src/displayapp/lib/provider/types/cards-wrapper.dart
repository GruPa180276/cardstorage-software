import 'package:rfidapp/provider/types/cards-status.dart';
import 'cards.dart';

class CardsWrapper {
  late Future<List<Cards>> _cards;
  late Future<List<CardsStatus>> _cardsStatus;

  CardsWrapper(
      Future<List<Cards>> cards, Future<List<CardsStatus>> cardsStatus) {
    this._cards = cards;
    this._cardsStatus = cardsStatus;
  }
  void setCards(Future<List<Cards>> cards) {
    this._cards = cards;
  }

  void setCardsStatus(Future<List<CardsStatus>> cardsStatus) {
    this._cardsStatus = cardsStatus;
  }

  Future<List<Cards>> getCards() {
    return this._cards;
  }

  Future<List<CardsStatus>> getCardsStatus() {
    return this._cardsStatus;
  }
}
