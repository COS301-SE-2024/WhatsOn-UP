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
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Match app bar background to screen background
        elevation: 0, // Remove app bar elevation
        title: const CustomSearchBar(
          leading: Icons.search,
          placeholder: "Search for events",
          fontSize: 16.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchTile(),
      ),
    );
  }
}
