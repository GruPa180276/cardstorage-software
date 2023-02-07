import 'package:rfidapp/domain/authentication/user_secure_storage.dart';

class MicrosoftUser {
  static String? context;
  static String? businessPhones;
  static String? displayName;
  static String? givenName;
  static String? jobTitle;
  static String? mail;
  static String? mobilePhone;
  static String? officeLocation;
  static String? preferredLanguage;
  static String? surname;
  static String? userPrincipalName;
  static String? id;

  static Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "context": context ?? "",
      "businessPhones": businessPhones ?? "",
      "displayName": displayName ?? "",
      "givenName": givenName ?? "",
      "jobTitle": jobTitle,
      "mail": mail ?? "",
      "mobilePhone": mobilePhone ?? "",
      "officeLocation": officeLocation ?? "",
      "preferredLanguage": preferredLanguage ?? "",
      "surname": surname,
      "userPrincipalName": userPrincipalName ?? "",
      "id": id ?? "",
    });

    return jsonTest;
  }
}
