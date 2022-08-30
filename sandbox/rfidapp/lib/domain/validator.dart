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

  static bool validateDates(String von, String bis) {
    return ((von.isNotEmpty && bis.isNotEmpty) &&
        DateTime.parse(bis).millisecondsSinceEpoch >
            DateTime.parse(von).millisecondsSinceEpoch);
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    return (to.difference(from).inHours);
  }

  static String? funcEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte gessben Sie eine Email an';
    } else if (!Validator().validateEmail(value)) {
      return "Email nicht korrekt";
    }
  }

  static String? funcName(String? value) {
    if (value!.isEmpty) {
      return "Bitte Nachname angeben";
    } else if (!Validator().validateName(value)) {
      return "Nachname nicht korrekt";
    }
    return null;
  }

  static String? funcPassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }
}
