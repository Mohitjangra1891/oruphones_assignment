import 'package:flutter/material.dart';

import '../../res/colors.dart';

class SnackBarService {
  static void showSnackBar({
    required BuildContext context,
    required String message,
     Color backgroundColor =Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        showCloseIcon: true,
        closeIconColor: AppColors.primary_color,
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
      ),
    );
  }
}

