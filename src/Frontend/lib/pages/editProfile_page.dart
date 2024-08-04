import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../main.dart';
 import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:firstapp/pages/profilePage.dart';


import 'package:image_picker/image_picker.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/user_provider.dart';
class EditprofilePage extends StatefulWidget {


  EditprofilePage({
    Key? key,

  }) : super(key: key);

  @override
  _EditprofilePageState createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {

  Uint8List? _image;
  Future<void> selectImage() async {

    try {
      await pickImage(ImageSource.gallery);

    } catch (e) {
      print('Failed to pick image: $e');
    }

  }

  Future<void> pickImage(ImageSource source) async {
    userProvider userP = Provider.of<userProvider>(context,listen: false);
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {

        final Uint8List imageBytes = await image.readAsBytes();
        Api api = Api();
        var response = await api.uploadImage(imageBytes,userP.userId);
        print(response);
        if (response['success']) {
          print('Upload successful: ${response}');
          userP.profileImage = response['data']['media_link'];
          print('profile image: ${userP.profileImage}');
        } else {
          print('Upload failed: ${response['error']}');
        }
      } else {
        throw 'No image selected';
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isObscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

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
    final userP = context.watch<userProvider>();


    emailController.text = userP.email;
    nameController.text = userP.Fullname;

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
      body:  _isLoading
          ? const Center(child:SpinKitPianoWave(
        color:  Color.fromARGB(255, 149, 137, 74),
         size: 50.0,
      ))
          :SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTop(),
              const SizedBox(height: 30),
              _buildTextField("Fullname", nameController, false),
              // _buildTextField("Email", emailController, false),
              // _buildTextField("Password", passwordController, true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _editUser,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Save',

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
                          // userName: widget.userName,
                          // userEmail: widget.userEmail,
                          // userId: widget.userId,
                          // role: widget.role,
                          // profileImage: widget.profileImage,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel',

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
    userProvider userP = Provider.of<userProvider>(context);
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
                      image:  NetworkImage(userP.profileImage!),
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
                        image: NetworkImage(userP.profileImage!)),
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

      ),
    );
  }

  Future<void> _editUser() async {
    userProvider userp = Provider.of<userProvider>(context,listen: false);
    final user1 = supabase.auth.currentUser;
    setState(() {
      _isLoading = true;
    });
    String fullName;
    String userEmail;
    String newPassword;
    String profileImageBase64;
    Uint8List profileImageBytes = Uint8List(0);

    if (_formKey.currentState!.validate()) {
      if(nameController.text.isNotEmpty){
        userp.Fullname=nameController.text;
      }
      if(emailController.text.isNotEmpty){
        userp.email=emailController.text;
      }
      if(passwordController.text.isNotEmpty){
        userp.password=passwordController.text;
      }

      final adjustedName = userp.Fullname;

      final adjustedEmail = userp.email;

      final adjustedPassword =
          passwordController.text.isNotEmpty ? passwordController.text : '';
      // profileImageBase64 = _image != null
      //     ? base64Encode(_image!)
      //     : base64Encode(userp.profileimage!);
      // if(_image != null){
      //   userp.profileImage=_image;
      // }

      final user = User(
        name: adjustedName,
        email: adjustedEmail,
        password: adjustedPassword,
        userId: user1!.id,
        profileImage: userp.profileImage,
      );

      Api api = Api();

      // profileImageBase64 =base64Encode(userp.profileimage!);

      api
          .postChangeUser(user.name,user1.id)
          .then((response) {
        if (response['error'] != null) {
          print('An error occurred: ${response['error']}');
        } else {

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

              // setState(() {
              //   widget.profileImage = profileImageBytes;
              // });
            } catch (e) {
              print('Failed to decode base64 image: $e');
            }
          } else {
            print('Invalid base64 image string: $profileImage');
          }
          print('User profile updated successfully');
          // await Future.delayed(Duration(seconds: 2));

          // setState(() {
          //   _isLoading = false;
          // });
         //await
         showChangedDialog();


        }
      }).catchError((error) {
        print('Failed to update user profile: $error');
        _isLoading = false;

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
                    builder: (context) => ProfilePage(),
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
  String? profileImage;
  String? userStatus;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.userId,
    required this.profileImage,
    this.userStatus,
  });

  @override
   String toString() {//userId: $userId
    return 'User(name: $name, email: $email, password: $password, userId: $userId,userStatus: $userStatus)';
  }
}
