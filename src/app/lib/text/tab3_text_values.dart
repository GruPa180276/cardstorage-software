class Tab3DescrpitionProvider {
  String getAppTitle() {
    return "Card-View";
  }

  List<String> getDropDownValues() {
    return ['Automat auswählen...', '1', '2', '3'];
  }

  String getDropDownText() {
    return "Automat auswählen...";
  }
}

class Tab3AddStorageDescriptionProvider {
  String getAppBarTitle() {
    return "Add Cards";
  }

  String getNameFieldName() {
    return "Name";
  }

  String getHardwareIDofCardFieldName() {
    return "Anzahl Karten";
  }

  String getCardStorageFieldName() {
    return "Karten Storage";
  }

  String getButtonName() {
    return "Karte hinzufügen";
  }
}

class Tab3AlterStorageDescriptionProvider {
  String getAppBarTitle() {
    return "Card Settings";
  }

  String getNameFieldName() {
    return "Name";
  }

  String getHardwareIDofCardFieldName() {
    return "Anzahl Karten";
  }

  String getCardStorageFieldName() {
    return "Karten Storage";
  }

  String getButtonName() {
    return "Änderungen speichern";
  }
}
