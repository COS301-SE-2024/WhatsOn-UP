// widgets/SearchTile.dart
import 'package:flutter/material.dart';
import 'package:firstapp/widgets/SearchImageTile.dart';

class SearchTile extends StatelessWidget {
  final Function(String) onFilterSelected;

  SearchTile({required this.onFilterSelected});
  String technologyTitle ="Tech";
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        SearchImageTile(
          title: 'Technology',
          imageUrl: 'assets/images/Technology.jpg',
          onTap: (title) => onFilterSelected(technologyTitle),
        ),
        SearchImageTile(
          title: 'Entrepreneurship',
          imageUrl: 'assets/images/Entrepreneurship.jpg',
          onTap: (title) => onFilterSelected(title),
        ),
        SearchImageTile(
          title: 'Festival',
          imageUrl: 'assets/images/Festival.jpg',
          onTap: (title) => onFilterSelected(title),
        ),
        SearchImageTile(
          title: 'Health',
          imageUrl: 'assets/images/Sports & Fitness.jpg',
          onTap: (title) => onFilterSelected(title),
        ),
      ],
    );
  }
}
