class SessionUser {
  static String? _email;
  static bool? _priviliged;
  static String? _userFirstname;
  static String? _userLastname;
  static String? _userOfficeLocation;
  static fromJson(dynamic apiUser, dynamic? microsoftUser) {
    _email = apiUser["email"];
    _priviliged = apiUser["privileged"];
    _userFirstname = (microsoftUser == null)
        ? apiUser["firstname"]
        : microsoftUser["firstname"];
    _userLastname = (microsoftUser == null)
        ? apiUser["lastname"]
        : microsoftUser["lastname"];
    _userOfficeLocation = (microsoftUser == null)
        ? apiUser["officeLocation"]
        : microsoftUser["officeLocation"];
  }

  static String? getEmail() {
    return _email;
  }

  static bool? getPrivileged() {
    return _priviliged;
  }

  static String? getUserFirstname() {
    return _userFirstname;
  }

  static String? getUserLastname() {
    return _userLastname;
  }

  static String? getUserOfficeLocation() {
    return _userOfficeLocation;
  }
}
