

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/services/EventService.dart';
import 'package:firstapp/widgets/event_card.dart'as CategoryData;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:firstapp/widgets/theme_manager.dart';






import '../screens/InviteUsers.dart';



class ApplicationEvent extends StatefulWidget {
//  const ApplicationEvent({super.key});

  @override
  _ApplicationEventPageState createState() => _ApplicationEventPageState();
}

class _ApplicationEventPageState extends State<ApplicationEvent> {

  late Future<List<CategoryData.Category>> _categoriesFuture;
  late Future<List<CategoryData.Venue>> _venuesFuture;
  late TextEditingController _venueController;
  late TextEditingController _eventNameController;
  late TextEditingController _eventDescriptionController;
  late DateTime _startDateTime;
  late DateTime _endDateTime;
  late TextEditingController _startDateTimeController;
  late TextEditingController _endDateTimeController;
  late TextEditingController _guestsController;
  bool _isPublic = true;
  int _maxAttendees = 100;
  CategoryData.Venue? _selectedVenue;
  late List<CategoryData.Category> _categories = [];
  List<CategoryData.Venue> _venues = [];
  final _formKey = GlobalKey<FormState>();
  final _formKeyAI = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isAutoFillDataLoading = false;
  late TextEditingController _maxAttendeesController;
  late TutorialCoachMark tutorialCoachMark;
  bool _tutorialShown = false;
  List<XFile>? selectedImages = [];
  String? _selectedCategory;
  late TextEditingController _eventNameControllerAI;
  late TextEditingController _eventDescriptionControllerAI;
  List<dynamic> autoFillData = [];
  List<AutofillOption> autoFillOptions = [];


  List<Uint8List> imageBytesList = [];



  @override
  void initState() {
    super.initState();
    _categoriesFuture =
        EventService(Supabase.instance.client).fetchUniqueCategories();

    _venuesFuture = EventService(Supabase.instance.client).getLocations();

    _venueController = TextEditingController();
    _eventNameController = TextEditingController();
    _eventDescriptionController = TextEditingController();
    _eventNameControllerAI = TextEditingController();
    _eventDescriptionControllerAI = TextEditingController();
    _startDateTimeController = TextEditingController();
    _endDateTimeController = TextEditingController();
    _startDateTime = DateTime.now();
    _endDateTime = DateTime.now().add(const Duration(hours: 1));
    _guestsController = TextEditingController();
    Future.wait([_categoriesFuture, _venuesFuture]).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    //R _selectedCategory = predefinedCategories.isNotEmpty ? predefinedCategories[0] : null;
    _maxAttendeesController =
        TextEditingController(text: _maxAttendees.toString());

    _updateDateTimeControllers();

  }

  late Color myColor;

  late Size mediaSize;

  //List<XFile>? selectedImages;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _numberPickerKey = GlobalKey();
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  void dispose() {
    _venueController.dispose();
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _maxAttendeesController.dispose();
    _guestsController.dispose();
    _eventNameControllerAI.dispose();
    _eventDescriptionControllerAI.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    super.dispose();
  }


  void _updateMaxAttendeesFromTextField(String value) {
    final int? newValue = int.tryParse(value);
    if (_selectedVenue != null && newValue != null && newValue >= 1 &&
        newValue <= (_selectedVenue?.capacity ?? 100)) {
      setState(() {
        _maxAttendees = newValue;
      });
      _updateCapacityWarning();
    }
  }

  void _updateMaxAttendeesFromPicker(int value) {
    setState(() {
      _maxAttendees = value;
      _maxAttendeesController.text = _maxAttendees.toString();
    });
    _updateCapacityWarning();
  }

  List<Map<String, dynamic>> selectedMedia = [];
    Widget _buildImagePicker2() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upload Images and Videos:'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final List<XFile>? pickedFiles = await _picker.pickMultipleMedia();
              if (pickedFiles != null) {
                setState(() {
                  selectedMedia.clear();
                  for (XFile file in pickedFiles) {
                    selectedMedia.add({
                      'file': file,
                      'name': file.name,
                    });
                  }
                });
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Select Media'),
            ),
          ),
          if (selectedMedia.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 10,
                children: selectedMedia.map((media) {
                  final isVideo = media['name'].toLowerCase().endsWith('.mp4') ||
                      media['name'].toLowerCase().endsWith('.mov');
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isVideo ? Icons.video_library : Icons.image),
                      const SizedBox(width: 5),
                      Text(media['name']),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      );
    }

  Widget _buildNumberPickerWithTextField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [

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

          Container(
            key: _textFieldKey,
            width: 80,
            child: TextField(
              controller: _maxAttendeesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
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
            child: const Column(
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
            child: const Column(
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
      textStyleSkip: const TextStyle(
        color:Colors.red,
        fontSize: 18,
      ),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        setState(() {
          _tutorialShown = true;
        });
      },
    )..show(context: context);
  }

  String _formatDateTime(DateTime dateTime) {
  return "${dateTime.toLocal()}".split(' ')[0] + ' ' + 
         "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

  void _updateDateTimeControllers() {
    _startDateTimeController.text = _formatDateTime(_startDateTime);
    _endDateTimeController.text = _formatDateTime(_endDateTime);
  }

  Future<void> getAutofillData(eventName, eventDescription) async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    try {
      final response = await Api().getAutofillData(userP.JWT, eventName, eventDescription);

      if (response['data'] != null) {
        setState(() {
          // autoFillData = response['data'];
          autoFillOptions = (response['data'] as List)
              .map((item) => AutofillOption.fromJson(item))
              .toList();
        });

        _showAutofillOptions();
      }
    }
    catch (e) {
      print('Failed to get autofill data: $e');
    }
  }

  void _showAutofillOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AutofillOptionsWidget(
          options: autoFillOptions,
          onSelect: (AutofillOption selectedOption) {
            setState(() {
              _eventNameController.text = _eventNameControllerAI.text;
              _eventDescriptionController.text = selectedOption.description;
              _startDateTime = selectedOption.startDateTime;
              _endDateTime = selectedOption.endDateTime;
              _updateDateTimeControllers();
              _selectedCategory = selectedOption.category;
              _maxAttendees = selectedOption.maxAttendees;

              _selectedVenue = _venues.firstWhere(
                (venue) => venue.name == selectedOption.venue.venueName,
                orElse: () => CategoryData.Venue(name: 'No venue', capacity: 0, venueId: '', ac: false, wifi: false, dataProject: 0, docCam: false, mic: false, windows: false, available: false, ),
              );
              if (_selectedVenue != null) {
                _venueController.text = _selectedVenue!.name;
              }
            });
          },
        );
      },
    );
  }

  bool _isWarning = false;
  bool _isError = false;
  String _capacityMessage = '';

  void _updateCapacityWarning() {
    if (_selectedVenue == null || _maxAttendees == 0) {
      setState(() {
        _isWarning = false;
        _isError = false;
        _capacityMessage = '';
      });
      return;
    }

    double capacityPercentage = _maxAttendees / _selectedVenue!.capacity;
    
    if (capacityPercentage < 0.25) {
      setState(() {
        _isWarning = false;
        _isError = true;
        _capacityMessage = 'Selected attendees is less than 25% of venue capacity. Please increase or choose a smaller venue.';
      });
    } else if (capacityPercentage < 0.5) {
      setState(() {
        _isWarning = true;
        _isError = false;
        _capacityMessage = 'Selected attendees is less than 50% of venue capacity. Consider increasing or choosing a smaller venue.';
      });
    } else {
      setState(() {
        _isWarning = false;
        _isError = false;
        _capacityMessage = '';
      });
    }
  }
  
    String? _selectedRecurrence = 'Does not repeat';


  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    userProvider userP = Provider.of<userProvider>(context,listen: false);
    EventProvider eventP=Provider.of<EventProvider>(context,listen: false);
    final Duration maxEventDuration = const Duration(hours: 23, minutes: 59);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.sparkles),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Enter Event Details'),
                        content: Form(
                          key: _formKeyAI,
                          child: _isAutoFillDataLoading
                            ? const SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Fill in the event name and a short description of the event. Our system will suggest an enhanced description, recommended venues, time and date, and categories based on the information you provide.',
                                    style: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _eventNameControllerAI,
                                    decoration: const InputDecoration(hintText: 'Event Name'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Event Name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _eventDescriptionControllerAI,
                                    decoration: const InputDecoration(hintText: 'Event Description'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Event Description is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                        ),
                        actions: _isAutoFillDataLoading
                          ? null
                          : [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Submit'),
                                onPressed: () async {
                                  if (_formKeyAI.currentState?.validate() == true) {
                                    String eventName = _eventNameControllerAI.text;
                                    String eventDescription = _eventDescriptionControllerAI.text;

                                    setState(() {
                                      _isAutoFillDataLoading = true;
                                    });

                                    await getAutofillData(eventName, eventDescription);

                                    setState(() {
                                      _isAutoFillDataLoading = false;
                                    });
                                  }
                                },
                              ),
                            ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name',   border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty ? 'Please enter event name' : null,

              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: const InputDecoration(labelText: 'Description',   border: OutlineInputBorder(),),
                validator: (value) => value == null || value.isEmpty ? 'Please enter event description' : null,
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const Center(
                child: SpinKitPianoWave(
                  color: Color.fromARGB(255, 149, 137, 74),
                  size: 50.0,
                ),
              )
              : FutureBuilder<List<CategoryData.Venue>>(
                future: _venuesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No venues available');
                  } else {
                    _venues = snapshot.data!;
                    return Autocomplete<CategoryData.Venue>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<CategoryData.Venue>.empty();
                        }
                        return _venues.where((venue) => venue.name
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()));
                      },
                      displayStringForOption: (CategoryData.Venue venue) => '${venue.name} \t-\t (Capacity: ${venue.capacity})',
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                        _venueController = controller;
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: const InputDecoration(
                            labelText: 'Venue',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a venue' : null,
                        );
                      },
                      onSelected: (CategoryData.Venue selectedVenue) {
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
              const SizedBox(height: 16.0),
              Visibility(
                visible: _venues.isNotEmpty && _selectedVenue != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Max Attendees',
                      style: TextStyle( fontSize: 16),
                    ),
                    const SizedBox(height: 8.0),
                    _buildNumberPickerWithTextField(),
                    if (_capacityMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _capacityMessage,
                        style: TextStyle(
                          color: _isError ? Colors.red : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

                        DropdownButtonFormField<String>(
            value: _selectedRecurrence,
            decoration: const InputDecoration(
              labelText: 'Recurrence',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Does not repeat',
                child: Text('Does not repeat'),
              ),
              DropdownMenuItem(
                value: 'Weekly',
                child: Text('Weekly'),
              ),
              DropdownMenuItem(
                value: 'Every 2 weeks',
                child: Text('Every 2 weeks'),
              ),
              DropdownMenuItem(
                value: 'Monthly',
                child: Text('Monthly'),
              ),
            ],
            onChanged: (String? newValue) {
              setState(() {
                _selectedRecurrence = newValue;
              });
            },
            validator: (value) => value == null
                ? 'Please select a recurrence option'
                : null,
          ),
          const SizedBox(height: 16.0),

              TextFormField(
                controller: _startDateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Start Date and Time',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
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
                        _updateDateTimeControllers();
                      });
                    }
                  }
                },
                validator: (value) {
                  if (_startDateTime.isBefore(DateTime.now())) {
                    return 'Start date and time must be in the future';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _endDateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'End Date and Time',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
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

                        final eventDuration = _endDateTime.difference(_startDateTime);
                        if (eventDuration > maxEventDuration) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Event duration cannot exceed 24 hours',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        _updateDateTimeControllers();
                      });
                    }
                  }
                },
                validator: (value) {
                  if (_endDateTime.isBefore(_startDateTime)) {
                    return 'End date and time must be after the start date and time';
                  }

                   final eventDuration = _endDateTime.difference(_startDateTime);
                  if (eventDuration > maxEventDuration) {
                    return 'Event duration cannot exceed 24 hours';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<List<CategoryData.Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No categories available');
                  } else {
                    _categories = snapshot.data!;
                    return DropdownButton<String>(
                      value: _selectedCategory,
                      hint: const Text('Select a category'),
                      isExpanded: true,
                      items: _categories.map((CategoryData.Category category) {
                        return DropdownMenuItem<String>(
                          value: category.name,  // Use the category name as the value
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;  // Update the selected category
                        });
                      },
                    );
                  }
                },
              ),



              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Event Visibility'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Switch(
                        value: _isPublic,
                        onChanged: (value) {
                          setState(() {
                            _isPublic = value;
                          });
                        },
                        activeTrackColor: isLightTheme
                            ? lightPrimaryColor.withOpacity(0.5)
                            : darkPrimaryColor.withOpacity(0.5),
                        activeColor: isLightTheme ? lightPrimaryColor : darkPrimaryColor,
                        inactiveThumbColor: isLightTheme
                            ? Colors.grey[400]
                            : Colors.grey[600],
                        inactiveTrackColor: isLightTheme
                            ? Colors.grey[300]
                            : Colors.grey[700],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isPublic ? 'Public' : 'Private',
                        style: TextStyle(
                          color: isLightTheme ? lightTextColor : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),



          const SizedBox(height: 16.0),
            _buildImagePicker2(),

              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (_isLoading || _isError)
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate() &&_selectedVenue != null && _selectedCategory != null) {
                    setState(() {
                      _isLoading = true;
                    });

                    try {


                      Map<String, String> metadata = {
                        'category': _selectedCategory!,
                      };


                      int recurrenceValue = 0;
                      switch (_selectedRecurrence) {
                        case 'Does not repeat':
                          recurrenceValue = 0;
                          break;
                        case 'Weekly':
                          recurrenceValue = 7;
                          break;
                        case 'Every 2 weeks':
                          recurrenceValue = 14;
                          break;
                        case 'Monthly':
                          recurrenceValue = 30;
                          break;
                      }

                      Map<String, dynamic> response = await Api().createEvent(
                        title: _eventNameController.text,
                        description: _eventDescriptionController.text,
                        startDate: _startDateTime,
                        endDate: _endDateTime,
                        locationId: _selectedVenue!.venueId,
                        maxParticipants: _maxAttendees,
                        metadata: metadata,
                        isPrivate: !_isPublic,
                        recurring: recurrenceValue,
                        JWT: userP.JWT,

                      );
                      Api api = Api();

                      if(imageBytesList!=null){
                        try{
                          // for(Uint8List imageBytes in imageBytesList){
                          //   Api().eventUploadImage(imageBytes, userP.userId, response['data']['id'], "test.png");
                          // }

                          for (var media in selectedMedia) {
                            XFile file = media['file'];
                            String originalFilename = media['name'];
                            Uint8List mediaBytes = await file.readAsBytes();
                            await api.eventUploadImage(mediaBytes, userP.JWT, response['data']['id'], originalFilename);
                          }


                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Event created successfully!'),
                              backgroundColor: Colors.green,
                            ),

                          );

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) =>InviteUsers(eventId:response['data']['id'])),
                          );
                      }
                      catch(e) {
                              print('Failed to submit application: $e');
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('There was an error submitting your application. Please try again later.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                        }
                      }


                    } catch (e) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create event: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      print("ARRRIVEDDDDD AT FINALLY");

                      eventP.refreshEvents(userP.JWT);
                      setState(() {
                        _isLoading = false;
                        selectedImages = null;
                      });
                     // eventP.refreshEvents();
                     // eventP.re
                    }
                  }
                },
                child: _isLoading
                    ? const SpinKitCircle(
                  color: Colors.white,
                  size: 24.0,
                )
                    : const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AutofillOption {
  final String description;
  final String category;
  final Venue venue;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int maxAttendees;

  AutofillOption({
    required this.description,
    required this.category,
    required this.venue,
    required this.startDateTime,
    required this.endDateTime,
    required this.maxAttendees,
  });

  factory AutofillOption.fromJson(Map<String, dynamic> json) {
    return AutofillOption(
      description: json['description'],
      category: json['category'],
      venue: Venue.fromJson(json['venue']),
      startDateTime: DateTime.parse(json['date']['startDateTime']),
      endDateTime: DateTime.parse(json['date']['endDateTime']),
      maxAttendees: json['venue']['maxAttendees'],
    );
  }
}

class Venue {
  final String venueId;
  final String venueName;

  Venue({required this.venueId, required this.venueName});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      venueId: json['venueId'],
      venueName: json['venueName'],
    );
  }
}


class AutofillOptionsWidget extends StatefulWidget {
  final List<AutofillOption> options;
  final Function(AutofillOption) onSelect;

  const AutofillOptionsWidget({
    Key? key,
    required this.options,
    required this.onSelect,
  }) : super(key: key);

  @override
  _AutofillOptionsWidgetState createState() => _AutofillOptionsWidgetState();
}

class _AutofillOptionsWidgetState extends State<AutofillOptionsWidget> {
  AutofillOption? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Choose an Autofill Option',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = option == selectedOption;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: isSelected ? 8 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = option;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.category,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            option.venue.venueName,
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Suggested Attendees: ' +
                            option.maxAttendees.toString(),
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDateTime(option.startDateTime, option.endDateTime),
                            style: const TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            option.description,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isSelected) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Tap the confirm selection button to choose this option',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.pop(context),
                    Navigator.pop(context),
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedOption != null
                      ? () {
                          widget.onSelect(selectedOption!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text('Confirm Selection'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime start, DateTime end) {
    final DateFormat dateFormat = DateFormat('E, MMM d, y');
    final DateFormat timeFormat = DateFormat('h:mm a');
    return '${dateFormat.format(start)} ${timeFormat.format(start)} - ${timeFormat.format(end)}';
  }
}