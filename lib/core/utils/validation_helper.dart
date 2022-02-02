abstract class ValidationHelper {
  /// uses regex to verify [email] pattern,
  /// following checks are performed
  /// - [email.length] < 200
  /// - [email] regex pattern is followed
  bool validateEmail(String email);

  /// Executes following checks
  /// - [password.length] is more than 8 and less than 100
  /// - [password] regex pattern is followed i.e. alphanumeric password with atleast one uppercase and one lowercase character
  bool validatePassword(String password);

  /// validates first name or last name of a user.
  /// checks performed
  /// - [name.length] is greater than 1 and less than 50 characters.
  /// - it should not be alpha numeric. Only uppercase and lowercase char accepted
  bool validateName(String name);
}

class ValidationHelperImpl implements ValidationHelper {
  @override
  bool validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    bool emailVerified;
    if (!regex.hasMatch(email))
      emailVerified = false;
    else
      emailVerified = true;

    return emailVerified && email.length < 200;
  }

  @override
  bool validatePassword(String password) {
    //   r'^
    //   (?=.*[A-Z])       // should contain at least one upper case
    //   (?=.*[a-z])       // should contain at least one lower case
    //   (?=.*?[0-9])      // should contain at least one digit
    //   (?=.*?[!@#\$&*~]) // should contain at least one Special character (omitted)
    //   .{8,}             // Must be at least 8 characters in length
    // $
    String passwordPattern = r'^([a-zA-Z]).{8,100}$';
    RegExp regex = RegExp(passwordPattern);

    bool passwordVerified;
    if (!regex.hasMatch(password))
      passwordVerified = false;
    else
      passwordVerified = true;
    return passwordVerified;
  }

  @override
  bool validateName(String name) {
    String namePattern = r'^([a-zA-Z]).{1,50}$';
    RegExp regex = RegExp(namePattern);

    bool nameVerified;
    if (!regex.hasMatch(name))
      nameVerified = false;
    else
      nameVerified = true;
    return nameVerified;
  }
}
