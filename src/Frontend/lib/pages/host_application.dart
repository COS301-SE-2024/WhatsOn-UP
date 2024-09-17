import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstapp/services/api.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class HostApplicationPage extends StatefulWidget {
  const HostApplicationPage({super.key});

  @override
  _HostApplicationPageState createState() => _HostApplicationPageState();
}

class _HostApplicationPageState extends State<HostApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  String _reason = '';
  String _studentEmail = '';
  String _duration = '1 week';
  DateTime _startDate = DateTime.now();
  bool _isStudent = true;
  Uint8List? _stickerImage;
  String? _imageName;
  bool _isLoading = false;

  final List<String> _durationOptions = ['1 week', '1 month', 'Permanent'];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List image = await pickedFile.readAsBytes();
      setState(() {
        _stickerImage = image;
        _imageName = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider user = Provider.of<userProvider>(context);
    String userId = user.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Application'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apply to become a host',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Are you a university student?',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Switch(
                        value: _isStudent,
                        onChanged: (bool value) {
                          setState(() {
                            _isStudent = value;
                            _formKey.currentState?.reset();
                            _stickerImage = null;
                            _studentEmail = '';
                          });
                        },
                      ),
                      Text(_isStudent ? 'Yes' : 'No',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_isStudent)
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
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Upload Permission Sticker'),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 200.0,
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Choose Image'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (_imageName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Selected image: $_imageName'),
                          ),
                      ],
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
                    onPressed: _isLoading ? null : () => _submitForm(userId),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Submit Application'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!_isStudent && _stickerImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a permission sticker')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await submitHostApplication(userId);

      // Reset form after it was submitted
      _formKey.currentState?.reset();
      setState(() {
        _stickerImage = null;
        _imageName = null;
        _reason = '';
        _studentEmail = '';
        _duration = '1 week';
        _startDate = DateTime.now();
        _isStudent = true;
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  Future<void> submitHostApplication(String userID) async {
    try {
      var result = await Api().applyForHost(
        reason: _reason,
        duration: _duration,
        fromWhen: _startDate,
        studentEmail: _isStudent ? _studentEmail : null,
        proofImage: !_isStudent ? _stickerImage : null,
        userId: userID,
      );

      print('Application submitted successfully: ${result['data']['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application submitted successfully. Please check your email for a verification link.'),),
      );
    } catch (e) {
      print('Failed to submit application: $e');
      setState(() {
        _isLoading = false;
      });

      if (e.toString().contains('already_applied')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already applied to be a host!'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'There was an error submitting your application. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
