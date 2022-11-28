class StorageValues {
  int id = 0;
  String name = "";
  int location = 0;
  String ipAdress = "";
  int numberOfCards = 0;

  void setID(int id) {
    this.id = id;
  }

  int getId() {
    return id;
  }

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return name;
  }

  void setLocation(int location) {
    this.location = location;
  }

  int getLocation() {
    return location;
  }

  void setIpAdress(String ipAdress) {
    this.ipAdress = ipAdress;
  }

  String getIpAdress() {
    return ipAdress;
  }

  void setNumberOfCards(int numberOfCards) {
    this.numberOfCards = numberOfCards;
  }

  int getNumberOfCards() {
    return numberOfCards;
  }
}
