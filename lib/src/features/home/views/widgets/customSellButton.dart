import 'package:flutter/material.dart';

class CustomSellButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87, // Button background color
        borderRadius: BorderRadius.circular(30), // Rounded corners
        border: Border.all(color: Colors.yellow, width: 3), // Yellow border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            blurRadius: 8, // How much blur
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Padding inside button
      child: Row(
        mainAxisSize: MainAxisSize.min, // Wrap content
        children: [
          Text(
            "Sell",
            style: TextStyle(
              color: Colors.yellow, // Text color
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(width: 6),
          Text(
            "+",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

