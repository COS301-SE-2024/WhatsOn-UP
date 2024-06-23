import 'package:flutter/material.dart';
import 'package:firstapp/services/EventService.dart';


class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with SingleTickerProviderStateMixin {
  EventService eventService = EventService();

  late String selectedDateRange="";
  late String selectedCapacityRange="";
  late String selectedEventType="";

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );

    _colorAnimation = ColorTween(begin: Colors.blue[800], end: Colors.pink[300]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle whiteTextTheme = Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Filter'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildFilterOptions("Date Range", ["Last week", "Today", "Next week"], (value) {
              setState(() {
                selectedDateRange = value;
              });
            }),
            _buildFilterOptions("Capacity Range", ["0 - 50", "50 - 100", "100 - 200", "200 - 300", "300 - 400", "400 - 500"], (value) {
              setState(() {
                selectedCapacityRange = value;
              });
            }),
            _buildFilterOptions("Event Type", ["Private", "Public"], (value) {
              setState(() {
                selectedEventType = value;
              });
            }),
            Spacer(),
            Center(
            child:Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.pink[300], ),
                child: Text(
                  "Filter Events",
                  style: whiteTextTheme,
                ),
                onPressed: _filterEvents,
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions(String title, List<String> options, Function(String) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium), // Use subtitle1 for the title style
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10.0,
            children: options.map((option) {
              bool isSelected = _isSelected(option);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedDateRange = "";
                      selectedCapacityRange = "";
                      selectedEventType = "";
                    } else {
                      onSelected(option);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isSelected ? _colorAnimation.value : Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isSelected
                              ? Icon(Icons.check_circle, color: Colors.white, size: 20.0)
                              : SizedBox.shrink(), // Show icon only when selected
                          SizedBox(width: 8.0), // Add space between icon and text
                          Text(
                            option,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isSelected ? _scaleAnimation.value : 1.0,
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedDateRange = "";
                                selectedCapacityRange = "";
                                selectedEventType = "";
                              } else {
                                onSelected(option);
                                _controller.forward(from: 0.0); // Start animation from beginning
                              }
                            });
                          },
                          child: SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  bool _isSelected(String option) {
    return option == selectedDateRange || option == selectedCapacityRange || option == selectedEventType;
  }

  void _filterEvents() {
    // Prepare date range timestamps
    DateTime now = DateTime.now();
    int startDate = 0;
    int endDate = 0;

    switch (selectedDateRange) {
      case "Today":
        startDate = now.millisecondsSinceEpoch;
        endDate = now.millisecondsSinceEpoch;
        break;
      case "Last week":
        startDate = now.subtract(Duration(days: 7)).millisecondsSinceEpoch;
        endDate = now.millisecondsSinceEpoch;
        break;
      case "Next week":
        startDate = now.millisecondsSinceEpoch;
        endDate = now.add(Duration(days: 7)).millisecondsSinceEpoch;
        break;
      default:
      // Handle default case or leave as is
    }
    print("Selected Date Range: $selectedDateRange, Start Date: $startDate, End Date: $endDate");

    // Prepare capacity range
    int minCapacity = 0;
    int maxCapacity = 0;

    switch (selectedCapacityRange) {
      case "0 - 50":
        minCapacity = 0;
        maxCapacity = 50;
        break;
      case "50 - 100":
        minCapacity = 50;
        maxCapacity = 100;
        break;
      case "100 - 200":
        minCapacity = 100;
        maxCapacity = 200;
        break;
      case "200 - 300":
        minCapacity = 200;
        maxCapacity = 300;
        break;
      case "300 - 400":
        minCapacity = 300;
        maxCapacity = 400;
        break;
      case "400 - 500":
        minCapacity = 400;
        maxCapacity = 500;
        break;
      default:
      // Handle default case or leave as is
    }

    // Prepare event type
    bool isPrivate = selectedEventType == "Private";

    // Call EventService to filter events
    eventService.filterEvents(startDate.toString(), endDate.toString(), minCapacity, maxCapacity, isPrivate).then((events) {
      // Handle the filtered events
      print("Filtered Events: $events");
      // Example: Displaying events in rows
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Filtered Events"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: events.map<Widget>((event) => _buildEventRow(event)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      print("Error filtering events: $error");
      // Handle error
    });
  }

  Widget _buildEventRow(dynamic event) {
    // Customize this based on your event structure
    return ListTile(
      title: Text(event['title']),
      subtitle: Text(event['description']),

      // Add more fields as needed
    );
  }

}
