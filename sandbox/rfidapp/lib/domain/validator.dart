class Validator {
  // regular expression to check if string

  double validatePassword(String pass) {
    RegExp passvalid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    double passwordStrength = 0;

    String password = pass.trim();
    if (password.isEmpty) {
    } else if (password.length < 6) {
      passwordStrength = 1 / 4;
    } else if (password.length < 8) {
      passwordStrength = 2 / 4;
    } else {
      if (passvalid.hasMatch(password)) {
        passwordStrength = 4 / 4;
      } else {
        passwordStrength = 3 / 4;
      }
    }
    return passwordStrength;
  }

  bool validateName(String name) {
    RegExp nameValid = RegExp(r"^([A-ZÖÄÜ][a-zäöüß]+)+$");
    return (nameValid.hasMatch(name));
  }

  bool validateEmail(String email) {
    RegExp emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailValid.hasMatch(email);
  }
}
