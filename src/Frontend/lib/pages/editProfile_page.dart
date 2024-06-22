import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:firstapp/pages/profilePage.dart';


import 'package:image_picker/image_picker.dart';
import 'package:firstapp/services/api.dart';

class EditprofilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userId;
  final String role;
  Uint8List? profileImage;

  EditprofilePage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.role,
    required this.profileImage,
  }) : super(key: key);

  @override
  _EditprofilePageState createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {
  Uint8List? _image;

  Future<void> selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<Uint8List> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      return await image.readAsBytes();
    } else {
      throw 'No image selected';
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isObscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.userEmail;
    nameController.text = widget.userName;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTop(),
              const SizedBox(height: 30),
              _buildTextField("Full name", nameController, false),
              _buildTextField("Email", emailController, false),
              _buildTextField("Password", passwordController, true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _editUser,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userName: widget.userName,
                          userEmail: widget.userEmail,
                          userId: widget.userId,
                          role: widget.role,
                          profileImage: widget.profileImage,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Center(
      child: Stack(
        children: [
          _image != null
              ? Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(_image!),
                    ),
                  ),
                )
              : Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(widget.profileImage!)),
                  ),
                ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              child: IconButton(
                  onPressed: selectImage,
                  icon: Icon(Icons.add_a_photo),
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isObscurePassword : false,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                  icon: Icon(
                    isObscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : null,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: labelText,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        validator: (value) {
          if (value != null && !value.isEmpty) {
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
          }
          return null;
        },
      ),
    );
  }

  Future<void> _editUser() async {
    String fullName;
    String userEmail;
    String newPassword;
    String profileImageBase64;
    Uint8List profileImageBytes = Uint8List(0);

    if (_formKey.currentState!.validate()) {
      final adjustedName = nameController.text.isNotEmpty
          ? nameController.text
          : widget.userName;
      final adjustedEmail = emailController.text.isNotEmpty
          ? emailController.text
          : widget.userEmail;
      final adjustedPassword =
          passwordController.text.isNotEmpty ? passwordController.text : '';
      profileImageBase64 = _image != null
          ? base64Encode(_image!)
          : base64Encode(widget.profileImage!);

      final user = User(
        name: adjustedName,
        email: adjustedEmail,
        password: adjustedPassword,
        userId: widget.userId,
        profileImage: _image,
      );

      Api api = Api();

      profileImageBase64 = _image != null
          ? base64Encode(_image!)
          : base64Encode(widget.profileImage!);

      api
          .postChangeUser(user.name, user.email, profileImageBase64)
          .then((response) {
        if (response['error'] != null) {
          print('An error occurred: ${response['error']}');
        } else {
          print(response);
          fullName = response['data']['user']['fullName'] ?? 'Unknown';
          userEmail = response['data']['user']['email'] ?? 'Unknown';
          String profileImage =
              response['data']['user']['profileImage'] ?? 'Unknown';

          bool isBase64(String input) {
            final RegExp base64 = RegExp(
              r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
            );
            return base64.hasMatch(input);
          }

          if (isBase64(profileImage)) {
            try {
              profileImageBytes = base64Decode(profileImage);
              print("getting to decode");
              setState(() {
                widget.profileImage = profileImageBytes;
              });
            } catch (e) {
              print('Failed to decode base64 image: $e');
            }
          } else {
            print('Invalid base64 image string: $profileImage');
          }
          print('User profile updated successfully');
          showChangedDialog();


        }
      }).catchError((error) {
        print('Failed to update user profile: $error');
      });
    }
  }


  Future<void> showChangedDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success!'),
          content: Text('Profile successfully updated.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userName: nameController.text.isNotEmpty
                          ? nameController.text
                          : widget.userName,
                      userEmail: emailController.text.isNotEmpty
                          ? emailController.text
                          : widget.userEmail,
                      userId: widget.userId,
                      role: widget.role,
                      profileImage: _image != null
                          ? _image
                          : widget.profileImage,
                    ),
                  ),
                ); // Navigate to ProfilePage
              },
            ),
          ],
        );
      },
    );
  }
}

class User {
  final String name;
  final String email;
  final String password;
  final String userId;
  Uint8List? profileImage;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.userId,
    required this.profileImage,
  });

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password, userId: $userId )';
  }
}
