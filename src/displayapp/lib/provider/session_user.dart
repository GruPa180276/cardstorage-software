class User {
  static String? _email;
  static bool? priviliged;

  static fromJson(dynamic json) {
    _email = json["email"];
    priviliged = json["privileged"];
  }
}
