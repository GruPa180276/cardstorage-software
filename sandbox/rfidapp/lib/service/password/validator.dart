class Validator {
  // regular expression to check if string
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;

  double validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.isEmpty) {
    } else if (_password.length < 6) {
      password_strength = 1 / 4;
    } else if (_password.length < 8) {
      password_strength = 2 / 4;
    } else {
      if (pass_valid.hasMatch(_password)) {
        password_strength = 4 / 4;
      } else {
        password_strength = 3 / 4;
      }
    }
    return password_strength;
  }
}
