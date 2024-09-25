import 'dart:convert';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../services/api.dart';
import '../widgets/event_card.dart';
import 'package:page_transition/page_transition.dart';
import 'SurveyRateCat_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<Category> categories = [];
  bool _isLoading = false;
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setLoading(true);
    userProvider userP = Provider.of<userProvider>(context, listen: false);
   EventProvider eventP = Provider.of<EventProvider>(context, listen: false);


    try {
      final List<Category> fetchedCategories = await eventP.fetchCategories(userP.JWT);
      setState(() {
        categories = fetchedCategories;

      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load categories';
      });
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: SpinKitPianoWave(
                color: Color.fromARGB(255, 149, 137, 74),
                size: 50.0,
              ),
            )
          :_errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'For a seamless experience, please complete the survey',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'What categories would you like to be recommended to you?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            category.isSelected = !category.isSelected;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: category.isSelected
                                ? const Color.fromARGB(255, 149, 137, 74)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: const Color.fromARGB(255, 149, 137, 74),
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: category.isSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _saveSelectedCategories,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('next'),
                  ),
                ),
              ],
            ),
    );
  }

  void _saveSelectedCategories() async {
    final selectedCategories =
        categories.where((category) => category.isSelected).toList();

    final String jsonCategories =
        jsonEncode(selectedCategories.map((e) => e.toJson()).toList());

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SurveyratecatScreen(jsonCategories: jsonCategories),
            isIos: true));
  }
}
