// Custom formatter to ensure only 2 decimal places and maintain the cursor position

import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value has no digits or is just a decimal, allow it
    if (newValue.text.isEmpty || newValue.text == '.') {
      return newValue;
    }

    // Regular expression to match valid number with decimal points
    final RegExp regExp = RegExp(r'^\d+\.?\d{0,' + decimalRange.toString() + r'}$');

    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }

    // If the input doesn't match, return the old value (i.e., do nothing)
    return oldValue;
  }
}
