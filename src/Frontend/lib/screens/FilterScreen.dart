import 'package:flutter/material.dart';
import 'package:firstapp/services/EventService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/widgets/FilteredResultScreen.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with SingleTickerProviderStateMixin {
  EventService eventService = EventService(Supabase.instance.client);

  late String selectedDateRange = "";
  late String selectedCapacityRange = "";
  late String selectedEventType = "";

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  static const Color goldishBrown = Color.fromARGB(255, 149, 137, 74);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );

    _colorAnimation = ColorTween(begin: goldishBrown, end: Colors.brown[300]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle whiteTextTheme = Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white);

    bool isSelectionMade = selectedDateRange.isNotEmpty || selectedCapacityRange.isNotEmpty || selectedEventType.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Filter'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildFilterSection("Date Range", ["Last week", "Today", "Next week"], (value) {
                  setState(() {
                    selectedDateRange = value;
                  });
                }),
                SizedBox(height: 16.0),
                _buildFilterSection("Capacity Range", ["0 - 50", "50 - 100", "100 - 200", "200 - 300", "300 - 400", "400 - 500"], (value) {
                  setState(() {
                    selectedCapacityRange = value;
                  });
                }),
                SizedBox(height: 16.0),
                _buildFilterSection("Event Type", ["Private", "Public"], (value) {
                  setState(() {
                    selectedEventType = value;
                  });
                }),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldishBrown, // Background color
                          ),
                          child: Text(
                            "Clear Selection",
                            style: whiteTextTheme,
                          ),
                          onPressed: isSelectionMade ? _clearSelection : null,
                        ),
                      ),
                      SizedBox(width: 16.0), // Add spacing between buttons
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldishBrown, // Background color
                          ),
                          child: Text(
                            "Filter Events",
                            style: whiteTextTheme,
                          ),
                          onPressed: isSelectionMade ? _filterEvents : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, Function(String) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.0),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            String option = options[index];
            bool isSelected = _isSelected(option);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (title == "Date Range") selectedDateRange = "";
                    if (title == "Capacity Range") selectedCapacityRange = "";
                    if (title == "Event Type") selectedEventType = "";
                  } else {
                    onSelected(option);
                    _controller.forward(from: 0.0); // Start animation from beginning
                  }
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? _colorAnimation.value : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.transparent : goldishBrown,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isSelected
                          ? Icon(Icons.check_circle, color: Colors.white, size: 20.0)
                          : SizedBox.shrink(),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isSelected(String option) {
    return option == selectedDateRange || option == selectedCapacityRange || option == selectedEventType;
  }

  void _filterEvents() async {
    DateTime now = DateTime.now();
    String? startDate;
    String? endDate;

    switch (selectedDateRange) {
      case "Today":
        startDate = now.toIso8601String();
        endDate = now.toIso8601String();
        break;
      case "Last week":
        startDate = now.subtract(Duration(days: 7)).toIso8601String();
        endDate = now.toIso8601String();
        break;
      case "Next week":
        startDate = now.toIso8601String();
        endDate = now.add(Duration(days: 7)).toIso8601String();
        break;
      default:
      // Handle other cases
    }

    int? maxCapacity;

    switch (selectedCapacityRange) {
      case "0 - 50":
        maxCapacity = 50;
        break;
      case "50 - 100":
        maxCapacity = 100;
        break;
      case "100 - 200":
        maxCapacity = 200;
        break;
      case "200 - 300":
        maxCapacity = 300;
        break;
      case "300 - 400":
        maxCapacity = 400;
        break;
      case "400 - 500":
        maxCapacity = 500;
        break;
      default:
      // Handle other cases
    }

    bool isPrivate = selectedEventType == "Private";
    try {
      List<Event> events = await eventService.filterEvents(startDate, endDate, maxCapacity, isPrivate);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FilteredResultScreen(filteredEvents: events),
      ));
    }
    catch (error) {
      print("Error filtering events: $error");
    }

  }

  void _clearSelection() {
    setState(() {
      selectedDateRange = "";
      selectedCapacityRange = "";
      selectedEventType = "";
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}