class Validators {
  Validators._(); // Private constructor to prevent instantiation
  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  static String? validatorForMobileNo(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (!RegExp(r'^(03[0-9]{2})[0-9]{7}$').hasMatch(value)) {
      return "Must start with 03 and be followed by 9 digits";
    } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return "Mobile number must be exactly 11 digits";
    } else {
      return null;
    }
  }

  static String? validatorForRollNo(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (value.length < 6) {
      return "Roll number must be at least 6 characters long";
    } else {
      return null;
    }
  }

  static String? validatorForCNICNo(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (value.length < 15) {
      return "CNIC number must be exactly of 13 digits";
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else if (value.length < 8) {
      return "Password must be atleast 8 characters long";
    } else {
      return null;
    }
  }
}
