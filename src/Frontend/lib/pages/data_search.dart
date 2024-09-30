import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final List<String> eventCategories = [
    'Academic Events',
    'Career and Professional Development',
    'Student Life and Activities',
    'Sports and Recreation',
    'Community Service and Engagement',
    'Arts and Culture',
    'Technology and Innovation',
    'Health and Wellness',
    'Diversity and Inclusion',
    'Sustainability and Environment',
    'Alumni Relations',
    'Special Occasions and Holidays'
  ];
  final recentCities = [
    'Academic Events',
    'Career and Professional Development',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggetionList = query.isEmpty
        ? recentCities
        : eventCategories
            .where((element) => element.startsWith(query))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.location_city),
        onTap: () {
          showResults(context);
        },
        title: RichText(
          text: TextSpan(
              text: suggetionList[index].substring(0, query.length),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggetionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggetionList.length,
    );
  }
}
