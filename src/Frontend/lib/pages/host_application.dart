import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HostApplicationPage extends StatefulWidget {
  @override
  _HostApplicationPageState createState() => _HostApplicationPageState();
}

class _HostApplicationPageState extends State<HostApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  String _reason = '';
  String _studentEmail = '';
  String _duration = '1 week';
  DateTime _startDate = DateTime.now();

  List<String> _durationOptions = ['1 week', '1 month', 'Permanent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apply to become a host',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Student Email',
                  hintText: 'Enter your university email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student email';
                  }
                  if (!value.endsWith('tuks.co.za')) {
                    return 'Please use a valid University of Pretoria email address';
                  }
                  return null;
                },
                onSaved: (value) => _studentEmail = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Reason for becoming a host',
                  hintText: 'Explain why you want to become a host',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a reason';
                  }
                  return null;
                },
                onSaved: (value) => _reason = value!,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                ),
                value: _duration,
                items: _durationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _duration = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null && picked != _startDate) {
                    setState(() {
                      _startDate = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('yyyy-MM-dd').format(_startDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Send to backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Application submitted successfully')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}