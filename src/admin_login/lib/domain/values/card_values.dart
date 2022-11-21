class CardValues {
  int id = 0;
  String name = "";
  int storageID = 0;
  int hardwareID = 0;

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

  void setStorage(int storageID) {
    this.storageID = storageID;
  }

  int getStorage() {
    return storageID;
  }

  void setHardwareID(int hardwareID) {
    this.hardwareID = hardwareID;
  }

  int getHardwareID() {
    return hardwareID;
  }
}
