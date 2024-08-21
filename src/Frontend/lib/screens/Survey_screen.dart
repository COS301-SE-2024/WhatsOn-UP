// import 'dart:convert';
//
// import 'package:flutter/material.dart';
//
// import '../pages/home_page.dart';
//
// class SurveyScreen extends StatefulWidget {
//   @override
//   _SurveyScreenState createState() => _SurveyScreenState();
// }
//
// class _SurveyScreenState extends State<SurveyScreen> {
//   final List<Category> categories = [
//     Category(name: 'Health'),
//     Category(name: 'Fitness'),
//     Category(name: 'Lifestyle'),
//     Category(name: 'Diet'),
//     Category(name: 'Wellness'),
//     Category(name: 'Technology'),
//     // Add more categories as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Categories'),
//       ),
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 3,
//         ),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 category.isSelected = !category.isSelected;
//               });
//             },
//             child: Card(
//               color: category.isSelected ? Colors.cyan : Colors.white,
//               child: Center(
//                 child: Text(
//                   category.name,
//                   style: TextStyle(
//                     color: category.isSelected ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _saveSelectedCategories,
//         child: const Icon(Icons.save),
//       ),
//     );
//   }
//
//   void _saveSelectedCategories() async {
//     final selectedCategories =
//     categories.where((category) => category.isSelected).toList();
//
//     final String jsonCategories =
//     jsonEncode(selectedCategories.map((e) => e.toJson()).toList());
//
//     print('Selected Categories: $jsonCategories');
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomePage()),
//     );
//     // Save the JSON string to a file or upload it to a server
//   }
// }
// class Category {
//   final String name;
//   bool isSelected;
//
//   Category({required this.name, this.isSelected = false});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'isSelected': isSelected,
//     };
//   }
// }
import 'dart:convert';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home_page.dart';
import '../services/api.dart';
import '../widgets/event_card.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<Category> categories = [];  // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    fetchCategories();  // Fetch categories when the screen initializes
  }
  Future<void> fetchCategories() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    Api api = Api();
    try {
      final List<Category> fetchedCategories = await api.getCategories(userId: userP.userId);

      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }
  // final List<Category> categories = [
  //   Category(name: 'Health'),
  //   Category(name: 'Fitness'),
  //   Category(name: 'Lifestyle'),
  //   Category(name: 'Diet'),
  //   Category(name: 'Wellness'),
  //   Category(name: 'Technology'),
  //   // Add more categories as needed
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Categories'),
      ),
      body: Column(
        children: [
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns
                crossAxisSpacing: 20.0, // Increase spacing between columns
                mainAxisSpacing: 20.0, // Increase spacing between rows
                childAspectRatio: 1.0, // Make the blocks more square
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
                      color: category.isSelected ? Color.fromARGB(255, 149, 137, 74) : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Color.fromARGB(255, 149, 137, 74),
                        width: 2.0,
                      ),
                    ),
                  // child: Card(
                  //   color: category.isSelected ? Color.fromARGB(255, 149, 137, 74) : Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     border: BorderSide(
                  //       color: Color.fromARGB(255, 149, 137, 74),
                  //       width: 2.0,
                  //     ),
                  //   ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: category.isSelected ? Colors.white : Colors.black,
                          fontSize: 16.0, // Adjust the text size
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
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
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

    print('Selected Categories: $jsonCategories');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );


  }
}


