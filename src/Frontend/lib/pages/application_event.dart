import 'package:flutter/material.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:flutter/cupertino.dart';

class ApplicationEvent extends StatefulWidget {
  const ApplicationEvent({Key? key}) : super(key: key);

  @override
  State<ApplicationEvent> createState() => _ApplicationEventState();
}

class _ApplicationEventState extends State<ApplicationEvent> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Create Event'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Details',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildInputField(eventNameController, label: 'Event Name'),
            SizedBox(height: 10),
            _buildInputField(eventDescriptionController, label: 'Description'),
            SizedBox(height: 20),
            _buildDateTimePicker(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showSubmitDialog(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller, {
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Date:'),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.calendar_today),
            SizedBox(width: 10),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text('Select Time:'),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.access_time),
            SizedBox(width: 10),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                '${selectedTime.format(context)}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String eventName = eventNameController.text;
      String eventDescription = eventDescriptionController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                profileImageUrl: 'https://example.com/your-profile-image.jpg')),
      );
      print('Event Name: $eventName');
      print('Event Description: $eventDescription');
      print(
          'Selected Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}');
      print('Selected Time: ${selectedTime.format(context)}');

      eventNameController.clear();
      eventDescriptionController.clear();
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
