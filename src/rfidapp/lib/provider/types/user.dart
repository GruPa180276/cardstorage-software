class User {
  String? context;
  String? businessPhones;
  String? displayName;
  String? givenName;
  String? jobTitle;
  String? mail;
  String? mobilePhone;
  String? officeLocation;
  String? preferredLanguage;
  String surname;
  String? userPrincipalName;
  String? id;

  @override
  User(
      {this.context,
      this.businessPhones,
      this.displayName,
      this.givenName,
      this.jobTitle,
      this.mail,
      this.mobilePhone,
      this.officeLocation,
      this.preferredLanguage,
      required this.surname,
      this.userPrincipalName,
      this.id});

  Map<String, dynamic> toJson() {
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

  static User fromJson(json) => User(
        context: json['@odata.context'],
        //businessPhones: json['businessPhones'],
        displayName: json['displayName'],
        givenName: json['givenName'],
        jobTitle: json['jobTitle'],
        mail: json['mail'],
        mobilePhone: json['mobilePhone'],
        officeLocation: json['officeLocation'],
        preferredLanguage: json['preferredLanguage'],
        surname: json['surname'],
        userPrincipalName: json['userPrincipalName'],
        id: json['id'],
      );
}
