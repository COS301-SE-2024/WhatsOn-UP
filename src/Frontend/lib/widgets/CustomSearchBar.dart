import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.leading,
    required this.placeholder,
    required this.fontSize,
  });

  final IconData leading;
  final String placeholder;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.black,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              leading,
              color: Colors.white, // Adjust icon color to white
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
                border: InputBorder.none, // Remove underline
              ),
              style: const TextStyle(color: Colors.white), // Adjust text color to white
            ),
          ),
        ],
      ),
    );
  }
}
