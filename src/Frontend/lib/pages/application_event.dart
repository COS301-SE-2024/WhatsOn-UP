import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/EventService.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:firstapp/services/api.dart';
import '../main.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


class ApplicationEvent extends StatefulWidget {
  @override
  _ApplicationEventPageState createState() => _ApplicationEventPageState();
}

class _ApplicationEventPageState extends State<ApplicationEvent> {
  late Future<List<String>> _categoriesFuture;
  late Future<List<Venue>> _venuesFuture;
  late TextEditingController _venueController;
  late TextEditingController _eventNameController;
  late TextEditingController _eventDescriptionController;
  late DateTime _startDateTime;
  late DateTime _endDateTime;
  bool _isPublic = true;
  int _maxAttendees = 100;
  Venue? _selectedVenue;
  List<String> _categories = [];
  List<Venue> _venues = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  late TextEditingController _maxAttendeesController;
  late TutorialCoachMark tutorialCoachMark;
  bool _tutorialShown = false;
  List<XFile>? selectedImages;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = EventService(Supabase.instance.client).fetchUniqueCategories();
    _venuesFuture = EventService(Supabase.instance.client).getLocations();

    _venueController = TextEditingController();
    _eventNameController = TextEditingController();
    _eventDescriptionController = TextEditingController();
    _startDateTime = DateTime.now();
    _endDateTime = DateTime.now().add(Duration(hours: 1));

    Future.wait([_categoriesFuture, _venuesFuture]).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });

    _maxAttendeesController = TextEditingController(text: _maxAttendees.toString());
  }

  @override
  void dispose() {
    _venueController.dispose();
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }

  void _updateMaxAttendeesFromTextField(String value) {
    final int? newValue = int.tryParse(value);
    if (newValue != null && newValue >= 1 && newValue <= (_selectedVenue?.capacity ?? 100)) {
      setState(() {
        _maxAttendees = newValue;
      });
    }
  }

  void _updateMaxAttendeesFromPicker(int value) {
    setState(() {
      _maxAttendees = value;
      _maxAttendeesController.text = _maxAttendees.toString();
    });
  }

  Widget _buildNumberPickerWithTextField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          // NumberPicker
          Expanded(
            child: NumberPicker(
              key: _numberPickerKey,
              value: _maxAttendees,
              minValue: 1,
              maxValue: _selectedVenue?.capacity ?? 100,
              itemHeight: 50,
              axis: Axis.horizontal,
              onChanged: _updateMaxAttendeesFromPicker,
            ),
          ),
          // TextField
          Container(
            key: _textFieldKey,
            width: 80,
            child: TextField(
              controller: _maxAttendeesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Type value',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              onChanged: _updateMaxAttendeesFromTextField,
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    final targets = [
      TargetFocus(
        identify: "numberPicker",
        keyTarget: _numberPickerKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Swipe to choose the maximum number of people who can attend.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "OR",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
      TargetFocus(
        identify: "textField",
        keyTarget: _textFieldKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Use this text field to directly input the number of attendees.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    ];

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        setState(() {
          _tutorialShown = true;
        });
      },
    )..show(context: context);
  }

  final GlobalKey _numberPickerKey = GlobalKey();
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name',   border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty ? 'Please enter event name' : null,

              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(labelText: 'Description',   border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty ? 'Please enter event description' : null,
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? Center(
                child: SpinKitPianoWave(
                  color: Color.fromARGB(255, 149, 137, 74),
                  size: 50.0,
                ),
              )
                  : FutureBuilder<List<Venue>>(
                future: _venuesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No venues available');
                  } else {
                    _venues = snapshot.data!;
                    return Autocomplete<Venue>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<Venue>.empty();
                        }
                        return _venues.where((venue) => venue.name
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()));
                      },
                      displayStringForOption: (Venue venue) => venue.name,
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                        _venueController = controller;
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            labelText: 'Venue',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a venue' : null,
                        );
                      },
                      onSelected: (Venue selectedVenue) {
                        setState(() {
                          _selectedVenue = selectedVenue;
                          _maxAttendees = selectedVenue.capacity;
                          _maxAttendeesController.text = _maxAttendees.toString();
                        });

                        if (!_tutorialShown) {
                          _showTutorial();
                        }
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              Visibility(
                visible: _venues.isNotEmpty && _selectedVenue != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Max Attendees',
                      style: TextStyle( fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    _buildNumberPickerWithTextField(),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date and Time',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_startDateTime),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        _startDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                controller: TextEditingController(text: _startDateTime.toString()),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'End Date and Time',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_endDateTime),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        _endDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
                controller: TextEditingController(text: _endDateTime.toString()),
              ),
              SizedBox(height: 16.0),
              FutureBuilder<List<String>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No categories available');
                  } else {
                    _categories = snapshot.data!;
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _categories.map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: false,
                          onSelected: (bool selected) {
                            // Handle category selection
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Event Visibility'),
                  Switch(
                    value: _isPublic,
                    onChanged: (bool value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                  }
                },
                child: _isLoading
                    ? SpinKitCircle(
                  color: Colors.white,
                  size: 24.0,
                )
                    : Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
