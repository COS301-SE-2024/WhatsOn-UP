import 'package:flutter/material.dart';

class SearchImageTile extends StatelessWidget {
  final String title;
  final String imageUrl;

  SearchImageTile({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Print received title and imageUrl for each tile
    print('SearchImageTile - Title: $title, ImageUrl: $imageUrl');

    return Container(
      margin: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Color(0xC1000000), BlendMode.luminosity),
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl), // Use NetworkImage for fetching images from URL
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
