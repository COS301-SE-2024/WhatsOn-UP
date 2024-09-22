import 'dart:convert';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../services/api.dart';
import '../widgets/event_card.dart';
import 'ThankYou_Survey.dart';

class StudentdetailSurvey extends StatefulWidget {
  final String jsonCategories;
  const StudentdetailSurvey({super.key, required this.jsonCategories});

  @override
  State<StudentdetailSurvey> createState() => _StudentdetailSurveyState();
}

class _StudentdetailSurveyState extends State<StudentdetailSurvey> {
  bool isStudent = false;
  String? selectedFaculty;
  final List<String> faculties = [
    'Faculty of Economic and Management Sciences',
    'Faculty of Education',
    'Faculty of Engineering, Built Environment and Information Technology',
    'Faculty of Health Sciences',
    'Faculty of Humanities',
    'Faculty of Law',
    'Faculty of Natural and Agricultural Sciences',
    'Faculty of Theology and Religion',
    'Faculty of Veterinary Science',
    'Mamelodi Campus',
    'Gordon Institute of Business Science (GIBS)',
  ];
  late List<Category> categories;
  String? _errorMessage;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Are you a student?'),
                    Checkbox(
                      value: isStudent,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isStudent = newValue ?? false;
                          if (!isStudent) {
                            selectedFaculty = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 60.0),
                if (isStudent)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Which faculty do you fall under?'),
                        DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select a faculty'),
                          value: selectedFaculty,
                          items: faculties.map((String faculty) {
                            return DropdownMenuItem<String>(
                              value: faculty,
                              key: Key(faculty),
                              child: Text(faculty),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFaculty = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 50.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveSelectedCategories,
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSelectedCategories() async {
    if (isStudent && selectedFaculty != null) {
      for (var category in categories) {
        category.faculty = selectedFaculty!;
      }
    }

    final String jsonCategories =
        jsonEncode(categories.map((e) => e.toJson()).toList());

    print('Selected Categories with ratings: $jsonCategories');

    final transformedData = {
      "preferences": categories.map((item) {
        final rating = double.tryParse(item.rating) ?? 0.0;
        return rating > 0.0
            ? {
          "categoryId": item.id,
          "preferenceValue": rating,
        }
            : null;
      }).where((item) => item != null).toList()
    };

    print('Transformed Data: $transformedData');


    try{
      userProvider userP = Provider.of<userProvider>(context, listen: false);
      Api api=Api();
    final response=await api.postRecommendationData(
        JWT: userP.JWT,
        data: transformedData,
      );

      if (response['status'] == 'success') {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: ThankYouScreen(),
            isIos: true,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Unexpected response: ${response['status']}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while submitting your data. Please try again later.';
      });
      print('Error transforming data: $e');
    }
  }
}
