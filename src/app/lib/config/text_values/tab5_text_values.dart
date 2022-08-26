class Tab5DescrpitionProvider {
  String getAddButtonDescription() {
    return "Rechte hinzufügen";
  }

  String getSearchButtonDescription() {
    return "Benutzer suchen";
  }

  String getShowUsersButtonDescription() {
    return "Benutzer anzeigen";
  }
}

class Tab5AddRightsDescriptionProvider {
  String getAppBarTitle() {
    return "Add Rights";
  }

  String getRightsFieldName() {
    return "Name Recht";
  }

  String getAccessFieldName() {
    return "Zugriff auf";
  }

  String getButtonName() {
    return "Recht hinzufügen";
  }
}

class Tab5AlterRightsDescriptionProvider {
  List<String> values = [];
  String text = "";

  String getAppBarTitle() {
    return "Rights Settings";
  }

  String getRightsFieldName() {
    return "Name Recht";
  }

  String getAccessFieldName() {
    return "Zugriff auf";
  }

  String getButtonName() {
    return "Recht hinzufügen";
  }

  String getShowRightsName() {
    return "Rechte anzeigen";
  }

  List<String> getDropDownValues() {
    return values;
  }

  String getDropDownText() {
    return text;
  }

  void setDropDownValues(List<String> values) {
    this.values = values;
  }

  void setDropDownText(String text) {
    this.text = text;
  }
}
