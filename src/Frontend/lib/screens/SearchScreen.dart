import 'package:flutter/material.dart';
import 'package:firstapp/widgets/CustomSearchBar.dart';
import 'package:firstapp/widgets/SearchTile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            padding: EdgeInsets.all(8.0),
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              color: Colors.white12,
            ),
            child: const CustomSearchBar( // Updated usage
              leading: Icons.search,
              placeholder: "Search for events",
              fontSize: 16.0, // Added fontSize to match the constructor
            ),
          ),
          Expanded(child: SearchTile()),
        ],
      ),
    );
  }
}
