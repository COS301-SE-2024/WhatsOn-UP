import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    Key? key,
    required this.leading,
    required this.placeholder,

    required this.fontSize,
  }) : super(key: key);

  final IconData leading;
  final String placeholder;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Icon(
            leading,
            color: Color(0x5FFFFFFF),
          ),
        ),
        Expanded(
          child: Text(
            placeholder,
            style: TextStyle(
              color: Color(0x5FFFFFFF),
              fontSize: fontSize,
            ),
          ),
        ),


      ],
    );
  }
}
