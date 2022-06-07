class Validator {
  static int _minLengthPass = 6;
  static int _maxLengthPass = 30;
  static bool isEmail(String email) {
   return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
  static bool isMinLengthPass(String text) {
   return text.length >= _minLengthPass;
  }
  static bool isMaxLengthPass(String text) {
   return text.length <= _maxLengthPass;
  }

  static bool isRequired(String text) {
   return text.trim().isNotEmpty;
  }
}