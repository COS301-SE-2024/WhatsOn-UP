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
  }

  @override
  void dispose() {
    _venueController.dispose();
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

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
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter event name' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a venue' : null,
                        );
                      },
                      onSelected: (Venue selectedVenue) {
                        setState(() {
                          _selectedVenue = selectedVenue;
                          _maxAttendees = selectedVenue.capacity;
                        });
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
          Visibility(
            visible: _venues.isNotEmpty,
            child:NumberPicker(
                value: _maxAttendees,
                minValue: 1,
                maxValue: _selectedVenue?.capacity ?? 100,
                onChanged: (value) => setState(() => _maxAttendees = value),
              ),
          ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Date and Time',
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _startDateTime)
                    setState(() {
                      _startDateTime = picked;
                    });
                },
                validator: (value) {
                  if (_startDateTime.isAfter(_endDateTime)) {
                    return 'Start date and time must be before end date and time';
                  }
                  return null;
                },
                controller: TextEditingController(
                    text: "${_startDateTime.toLocal()}".split(' ')[0]),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'End Date and Time',
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _endDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _endDateTime)
                    setState(() {
                      _endDateTime = picked;
                    });
                },
                validator: (value) {
                  if (_endDateTime.isBefore(_startDateTime)) {
                    return 'End date and time must be after start date and time';
                  }
                  return null;
                },
                controller: TextEditingController(
                    text: "${_endDateTime.toLocal()}".split(' ')[0]),
              ),
              SizedBox(height: 16.0),
              FutureBuilder<List<String>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (_isLoading) {
                    return SizedBox.shrink();
                  }
                  else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No categories available');
                  } else {
                    _categories = snapshot.data!;
                    return DropdownButtonFormField<String>(
                      items: _categories
                          .map((category) =>
                          DropdownMenuItem(value: category, child: Text(category)))
                          .toList(),
                      onChanged: (value) {},
                      decoration: InputDecoration(labelText: 'Category'),
                      validator: (value) =>
                      value == null ? 'Please select a category' : null,
                    );
                  }
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Event Visibility:'),
                  Switch(
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),
                  Text(_isPublic ? 'Public' : 'Private'),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform your submission logic here
    }
  }
}
