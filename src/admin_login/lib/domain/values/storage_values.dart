class StorageValues {
  String name = "";
  String location = "";
  int numberOfCards = 0;

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return name;
  }

  void setLocation(String location) {
    this.location = location;
  }

  String getLocation() {
    return location;
  }

  void setNumberOfCards(int numberOfCards) {
    this.numberOfCards = numberOfCards;
  }

  int getNumberOfCards() {
    return numberOfCards;
  }
}
