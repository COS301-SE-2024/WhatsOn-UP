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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Details',
              style: TextStyle(
                fontSize: 24,
                // color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(eventNameController, label: 'Event Name'),
            const SizedBox(height: 10),
            _buildInputField(eventDescriptionController, label: 'Description'),
            const SizedBox(height: 20),
            _buildDateTimePicker(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showSubmitDialog(context);
              },
              child: const Text('Submit'),
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
        border: const OutlineInputBorder(),
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
    final theme = Theme.of(context);
    final dateAndTimeColour = theme.brightness == Brightness.dark ? const Color.fromARGB(255, 58, 132, 218) : const Color.fromARGB(255, 13, 73, 151);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Date:'),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: TextStyle(color: dateAndTimeColour),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Select Time:'),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                '${selectedTime.format(context)}',
                style: TextStyle(color: dateAndTimeColour),
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
            builder: (context) => const ProfilePage(
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
