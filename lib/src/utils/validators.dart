class Validators {
  // Validator for required fields (not empty)
  static String? notEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Validator for email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Validator for password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    } else if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? confirmBankAccountNUmberValidator(String? confirmAccNum, String? accNum) {
    if (confirmAccNum == null || confirmAccNum.isEmpty) {
      return 'Account Number cannot be empty';
    } else if (confirmAccNum != accNum) {
      return 'Account Number do not match';
    }
    return null;
  }

  static final passwordRegEx = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  static final upperCaseRegEx = RegExp(r'[A-Z]');

  static final lowerCaseRegEx = RegExp(r'[a-z]');

  static final numberRegEx = RegExp(r'[0-9]');

  static final emailRegEx = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  static final mobileRegEx = RegExp(r'^[0-9]{10}$');

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (!mobileRegEx.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  // String? validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your email address';
  //   }
  //   if (!emailRegEx.hasMatch(value)) {
  //     return 'Please enter valid email address';
  //   }
  //   return null;
  // }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    //
    // if (!value.contains(upperCaseRegEx)) {
    //   return 'Password must contain at least 1 uppercase letter';
    // }
    //
    // if (!value.contains(lowerCaseRegEx)) {
    //   return 'Password must contain at least 1 lowercase letter';
    // }
    //
    // if (!value.contains(numberRegEx)) {
    //   return 'Password must contain at least 1 number';
    // }
    //
    // if (!passwordRegEx.hasMatch(value)) {
    //   return 'Password must contain at least 1 uppercase letter, 1 lowercase letter and 1 number';
    // }
    return null;
  }
// You can add more validators here, like phone number, etc.
}
