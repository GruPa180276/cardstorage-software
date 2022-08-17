import 'dart:math';

class Validator {
  // regular expression to check if string

  double validatePassword(String pass) {
    RegExp passvalid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    double password_strength = 0;

    String _password = pass.trim();
    if (_password.isEmpty) {
    } else if (_password.length < 6) {
      password_strength = 1 / 4;
    } else if (_password.length < 8) {
      password_strength = 2 / 4;
    } else {
      if (passvalid.hasMatch(_password)) {
        password_strength = 4 / 4;
      } else {
        password_strength = 3 / 4;
      }
    }
    return password_strength;
  }

  bool validateName(String name) {
    RegExp nameValid = RegExp(r"^[A-ZÄÖÜß][a-zäöüß]*");
    return (nameValid.hasMatch(name));
  }

  bool validateEmail(String email) {
    RegExp emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailValid.hasMatch(email);
  }
}
