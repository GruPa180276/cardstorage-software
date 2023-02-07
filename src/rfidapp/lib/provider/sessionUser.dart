class SessionUser {
  static String? _email;
  static bool? _priviliged;

  static fromJson(dynamic json) {
    _email = json[0]["email"];
    _priviliged = json[1]["privileged"];
  }

  static String? getEmail() {
    return _email;
  }

  static bool? getPrivileged() {
    return _priviliged;
  }
}
