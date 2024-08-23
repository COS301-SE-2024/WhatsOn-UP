import 'dart:convert';
import 'package:firstapp/surveys/studentdetail_survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/event_card.dart';

class SurveyratecatScreen extends StatefulWidget {
  final String jsonCategories;

  const SurveyratecatScreen({super.key, required this.jsonCategories});

  @override
  State<SurveyratecatScreen> createState() => _SurveyratecatScreenState();
}

class _SurveyratecatScreenState extends State<SurveyratecatScreen> {
  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    _parseCategories();
  }

  void _parseCategories() {
    try {
      final List<dynamic> jsonList = jsonDecode(widget.jsonCategories);

      categories = jsonList.map((jsonItem) {
        final Map<String, dynamic> item = jsonItem as Map<String, dynamic>;
        return Category(
          id: item['id'],
          name: item['name'],
          rating: item['rating'].toString(),
          faculty: item['faculty'] ?? '',
        );
      }).toList();
    } catch (e) {

      print('Error parsing categories: $e');
      categories = [];
    }
  }

  void _handleRating(int index, double rating) {
    setState(() {
      categories[index].rating = rating.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                'Tap on a star to rate each category. Your rating will be saved automatically.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(
                      category.name,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Center(
                      child: RatingBar.builder(
                        initialRating: double.tryParse(category.rating) ?? 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 149, 137, 74),
                        ),
                        onRatingUpdate: (rating) {
                          _handleRating(index, rating);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveSelectedCategories,
                  child: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveSelectedCategories() async {
    final String jsonCategories =
        jsonEncode(categories.map((e) => e.toJson()).toList());

    print('Selected Categories with ratings: $jsonCategories');
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: StudentdetailSurvey(jsonCategories: jsonCategories),
        isIos: true,
      ),
    );
  }
}
