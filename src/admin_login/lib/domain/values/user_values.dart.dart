class UserValues {
  int callerName = 0;
  String firstName = "";
  String lastName = "";
  String mail = "";
  String phoneNumber = "";

  void setCallerName(int callerName) {
    this.callerName = callerName;
  }

  int getCallerName() {
    return callerName;
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  String getFirstName() {
    return firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  String getLastName() {
    return lastName;
  }

  void setUserMail(String mail) {
    this.mail = mail;
  }

  String getUserMail() {
    return mail;
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  String getPhoneNumber() {
    return phoneNumber;
  }
}