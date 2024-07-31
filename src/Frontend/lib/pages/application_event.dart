
import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:firstapp/services/api.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/events_providers.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
class ApplicationEvent extends StatefulWidget {
  const ApplicationEvent({
    super.key,

  });

  @override
  State<ApplicationEvent> createState() => _ApplicationEventState();

}
class Category{
  final int id;
  final String name;
  Category({
    required this.id,
    required this.name,
  });
}
class _ApplicationEventState extends State<ApplicationEvent> {
  static final List<Category> _categories = [
    Category(id: 1, name: 'Technology'),
    Category(id: 2, name: 'Music'),
    Category(id: 3, name: 'Food'),
    Category(id: 4, name: 'Sports'),
    Category(id: 5, name: 'Art'),
    Category(id: 6, name: 'Science'),
    Category(id: 7, name: 'Charity & Causes'),
    Category(id: 8, name: 'Entrepreneurship'),
  ];
  final _items=_categories.map((category) => MultiSelectItem<Category>(category, category.name)).toList();
  List<Category> _selectedCategories = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  @override
  void initState() {
    _selectedCategories=_categories;
    super.initState();
  }
  late Color myColor;
  late Size mediaSize;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController maxAttendeesController = TextEditingController();
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  List<XFile>? selectedImages;
  bool isPublic = true;


  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create Event'),
      ),
      body: _buildForm(),

    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(eventNameController, label: 'Event Name'),
              const SizedBox(height: 10),
              _buildInputField(eventDescriptionController, label: 'Description'),
              const SizedBox(height: 10),
              _buildInputField(venueController, label: 'Venue'),
              const SizedBox(height: 10),
              _buildInputField(maxAttendeesController, label: 'Max Attendees', keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildDateTimePicker('Start', startDate, startTime, (date, time) {
                setState(() {
                  startDate = date;
                  startTime = time;
                });
              }),
              const SizedBox(height: 20),
              _buildDateTimePicker('End', endDate, endTime, (date, time) {
                setState(() {
                  endDate = date;
                  endTime = time;
                });
              }),
              const SizedBox(height: 20),
              const Text('Event Category:'),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.4),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      key: _multiSelectKey,
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      buttonText: const Text("Categories"),
                      title: const Text("Categories"),
                      items: _items,
                      onConfirm: (values) {
                        setState(() {
                          _selectedCategories = values.cast<Category>();
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            _selectedCategories.remove(value);
                          });
                        },
                      ),
                    ),
                    _selectedCategories.isEmpty
                        ? Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "None selected",
                          style: TextStyle(color: Colors.black54),
                        ))
                        : Container(),
                  ],

                ),
              ),

              const SizedBox(height: 20),
              _buildPrivacyToggle(),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 35),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showSubmitDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle() {
  final theme = Theme.of(context);
  final isLightTheme = theme.brightness == Brightness.light;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Event Visibility:'),
      const SizedBox(height: 10),
      Row(
        children: [
          Switch(
            value: isPublic,
            onChanged: (value) {
              setState(() {
                isPublic = value;
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
            isPublic ? 'Public' : 'Private',
            style: TextStyle(
              color: isLightTheme ? lightTextColor : Colors.white,
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildInputField(TextEditingController controller, {required String label, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker(String label, DateTime date, TimeOfDay time, void Function(DateTime, TimeOfDay) onDateTimeChanged) {
    final theme = Theme.of(context);
    final dateAndTimeColour = theme.brightness == Brightness.dark ? const Color.fromARGB(255, 58, 132, 218) : const Color.fromARGB(255, 13, 73, 151);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label Date and Time:'),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (pickedTime != null) {
                    onDateTimeChanged(pickedDate, pickedTime);
                  }
                }
              },
              child: Text(
                '${date.day}/${date.month}/${date.year} ${time.format(context)}',
                style: TextStyle(color: dateAndTimeColour),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload Images:'),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final List<XFile> pickedFiles = await _picker.pickMultiImage();
            setState(() {
              selectedImages = pickedFiles;
            });
                    },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.grey, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
          ),
          child: const Text('Select Images'),
        ),
        if (selectedImages != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
              spacing: 10,
              children: selectedImages!.map((file) => Text(file.name)).toList(),
            ),
          ),
      ],
    );
  }

  void _submitForm() {
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);


    // eventP.addEventHome(
    // );
   // eventP.addEventHome();
    final userSuperbase = supabase.auth.currentUser;
  if (_formKey.currentState!.validate()) {
    String eventName = eventNameController.text;
    String eventDescription = eventDescriptionController.text;
    String venue = venueController.text;
    int? maxAttendees = int.tryParse(maxAttendeesController.text);

    // Combine date and time
    DateTime startDateTime = DateTime(
      startDate.year, startDate.month, startDate.day,
      startTime.hour, startTime.minute
    );
    DateTime endDateTime = DateTime(
      endDate.year, endDate.month, endDate.day,
      endTime.hour, endTime.minute
    );


      eventNameController.clear();List<String>? mediaUrls = selectedImages?.map((file) => file.path).toList();
      List<String> selectedCategoryNames = _selectedCategories.map((category) => category.name).toList();

      // eventP.addEventHome(newEvent);



      Api().createEvent(
        title: eventName,
        description: eventDescription,
        startDate: startDateTime,
        endDate: endDateTime,
        location: venue,
        maxParticipants: maxAttendees,
        isPrivate: !isPublic,
        media: mediaUrls,
        userId: userSuperbase!.id,
        metadata: selectedCategoryNames
      ).then((response) {
        print('Event created successfully');
        // print('The Event: ');
        //   print (response['data']);
        eventP.addEventHome(response['data']);
        // eventP.;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );

        eventDescriptionController.clear();
      venueController.clear();
      maxAttendeesController.clear();
      setState(() {
        selectedImages = null;
        isPublic = true;
      });
    }).catchError((error) {
      print('Error creating event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $error')),
      );
    });
  }
}

  void showSubmitDialog(BuildContext context) {
    bool isValid = _formKey.currentState!.validate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(isValid ? 'Submitted' : 'Could not submit'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
                if (isValid) {
                  _submitForm();
                }
              },
            ),
          ],
        );
      },
    );
  }



}

