class StorageValues {
  int id = 0;
  String name = "";
  String location = "";
  String ipAdress = "";
  String numberOfCards = "";

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

  void setLocation(String location) {
    this.location = location;
  }

  String getLocation() {
    return location;
  }

  void setIpAdress(String ipAdress) {
    this.ipAdress = ipAdress;
  }

  String getIpAdress() {
    return ipAdress;
  }

  void setNumberOfCards(String numberOfCards) {
    this.numberOfCards = numberOfCards;
  }

  String getNumberOfCards() {
    return numberOfCards;
  }
}
