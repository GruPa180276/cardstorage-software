class CardValues {
  int id = 0;
  String name = "";
  String cardStorage = "";
  String hardwareID = "";

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

  void setStorage(String cardStorage) {
    this.cardStorage = cardStorage;
  }

  String getStorage() {
    return cardStorage;
  }

  void setHardwareID(String hardwareID) {
    this.hardwareID = hardwareID;
  }

  String getHardwareID() {
    return hardwareID;
  }
}
