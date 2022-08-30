class Tab1TextValues {
  String getAppTitle() {
    return "Admin-Login";
  }

  String getDrawerSettingsTabName() {
    return "Settings";
  }

  String getDrawerAppInfoTabName() {
    return "AppInfo";
  }

  String getDrawerIconPath() {
    return "img/splashscreen.jpg";
  }

  List<String> getDropDownValues() {
    return ['Select Storage...', '1', '2', '3'];
  }

  String getDropDownText() {
    return "Select Storage...";
  }

  String getWelcomePageText() {
    return "Hier werden Ihnen kurz die Funktion des Admin Logins erklärt: \n\n"
        "- In aktuellen Tab können Sie sich den Status aller Karten anzeigen lassen.\n\n"
        "- Im zweiten Tab können Sie neue Kartentresore hinzufügen oder berbeiten.\n\n"
        "- Im dritten Tab können Sie neue Karten hinzufügen oder bearbeiten.\n\n"
        "- Im vierten Tab können Sie neue Benutzer anlegen oder bearbeiten.\n\n"
        "- Im fünften Tab können Sie Statistiken anzeigen lassen oder exportieren.\n\n"
        "Aktuelle Version: v0.1.1 Beta";
  }

  String getWelcomePageHeadline() {
    return "Willkommen im Admin Login";
  }
}
