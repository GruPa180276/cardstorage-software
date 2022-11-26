class StorageProperties {
  static String? _storageId;
  static String? _ipAdress;
  static String? _location;

  static String? getStorageId() {
    return _storageId;
  }

  static String? getIpAdress() {
    return _ipAdress;
  }

  static String? getLocation() {
    return _location;
  }

  static void setStorageId(String value) {
    _storageId = value;
  }

  static void setIpAdress(String value) {
    _ipAdress = value;
  }

  static void setLocation(String value) {
    _location = value;
  }
}
