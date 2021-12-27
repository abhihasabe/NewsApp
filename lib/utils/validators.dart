class Validators {
  static isValidEmail(String email) {
    final regularExpression = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    return regularExpression.hasMatch(email);
  }
  static isValidPassword(String password) => password.length >= 5;

  static isEmpty(String name) {
    if(name.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  static isPasswordMatch(String password, String confirmPassword) {
    if(password!=confirmPassword){
      return true;
    }else{
      return false;
    }
  }
}