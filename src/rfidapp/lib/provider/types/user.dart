class User {
  String email;

  @override
  User({
    required this.email,
  });

  factory User.fromJson(dynamic json) {
    return User(email: json["email"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonTest = <String, dynamic>{};
    jsonTest.addAll({
      "email": email,
    });
    return jsonTest;
  }
}
