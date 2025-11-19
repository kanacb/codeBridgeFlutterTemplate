class Validators {
  static bool isStringNotEmpty(String? value) {
    if ((value == null) || (value.isEmpty)) {
      return false;
    }
    return true;
  }

  static bool hasLength(String? value, int l) {
    if (value!.length <= l) {
      return true;
    }
    return false;
  }

  static bool isEmail(String? value) {
    if (isStringNotEmpty(value)) {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value!)) {
        return true;
      }
    }
    return false;
  }

  static bool isPassword(String? value) {
    return isStringNotEmpty(value);
  }

  static bool hasUppercase(String? value) {
    if (value!.contains(RegExp(r'[A-Z]'))) {
      return true;
    }
    return false;
  }

  static bool hasSymbol(String? value) {
    if (value!.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return true;
    }
    return false;
  }

  static bool hasNumber(String? value) {
    if (value!.contains(RegExp(r'[0-9]'))) {
      return true;
    }
    return false;
  }

  static bool isPasswordConfirmed(String? value, [String? first]) {
    if (isStringNotEmpty(value)) {
      if (value!.length >= 6) {
        if (first != null) {
          return value == first;
        }
        return true;
      }
    }
    return false;
  }

  static bool isValidUri(String input) {
    return Uri.tryParse(input)?.hasScheme ?? false;
  }
}
