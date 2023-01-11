import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rfidapp/domain/storage_properties.dart';

class AssetFiles {
  static Future<void> setProperties() async {
    final String response =
        await rootBundle.loadString('assets/properties.json');
    final data = await json.decode(response);
    StorageProperties.setIpAdress(data["ipadress"]);
    StorageProperties.setLocation(data["location"]);
    StorageProperties.setStorageId(data["name"]);
  }
}
