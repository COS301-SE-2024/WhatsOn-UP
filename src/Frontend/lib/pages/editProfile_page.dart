import 'dart:typed_data';
import 'package:firstapp/main.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api.dart';
import '../providers/user_provider.dart';

class EditprofilePage extends StatefulWidget {
  EditprofilePage({Key? key}) : super(key: key);

  @override
  _EditprofilePageState createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {
  Uint8List? _image;

  Future<void> pickImage(ImageSource source) async {
    final userP = Provider.of<userProvider>(context, listen: false);
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();

        setState(() {
          _image = imageBytes;
        });

        Api api = Api();
        var response = await api.uploadImage(imageBytes, userP.userId);

        if (response['status'] == 'success') {
          print('Upload successful: $response');
          String newProfileImage = response['data']['media_link'];

          setState(() {
            userP.profileImage = newProfileImage;
          });

          userP.notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image updated successfully')),
          );
        } else {
          print('Upload failed: $response');
          throw Exception('Upload failed');
        }
      } else {
        throw Exception('No image selected');
      }
    } catch (e) {
      print('Failed to pick or upload image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update image: $e')),
      );
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
    final userP = Provider.of<userProvider>(context, listen: false);
    emailController.text = userP.email;
    nameController.text = userP.Fullname;
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

    final theme = Theme.of(context);
    return Consumer<userProvider>(
      builder: (context, userP, child) {
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
          body: _isLoading
              ? const Center(
                  child: SpinKitPianoWave(
                  color: Color.fromARGB(255, 149, 137, 74),
                  size: 50.0,
                ))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTop(),
                        const SizedBox(height: 30),
                        _buildTextField("Fullname", nameController, false),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _editUser,
                            child: Text('Save'),
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
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTop() {
    final userP = Provider.of<userProvider>(context);
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: _image != null
                    ? MemoryImage(_image!)
                    : (userP.profileImage != null &&
                                userP.profileImage!.isNotEmpty
                            ? NetworkImage(userP.profileImage!)
                            : AssetImage('assets/default_profile_image.png'))
                        as ImageProvider,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: Icon(Icons.add_a_photo),
              ),
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
    userProvider userp = Provider.of<userProvider>(context, listen: false);
    final user1 = supabase.auth.currentUser;
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      if (nameController.text.isNotEmpty) {
        userp.Fullname = nameController.text;
      }
      if (emailController.text.isNotEmpty) {
        userp.email = emailController.text;
      }
      if (passwordController.text.isNotEmpty) {
        userp.password = passwordController.text;
      }

      final adjustedName = userp.Fullname;
      final adjustedEmail = userp.email;
      final adjustedPassword =
          passwordController.text.isNotEmpty ? passwordController.text : '';

      final user = User(
        name: adjustedName,
        email: adjustedEmail,
        password: adjustedPassword,
        userId: user1!.id,
        profileImage: userp.profileImage,
      );

      Api api = Api();

      api.postChangeUser(user.name, user1.id).then((response) {
        if (response['error'] != null) {
          print('An error occurred: ${response['error']}');
        } else {
          String fullName = response['data']['user']['fullName'] ?? 'Unknown';
          String userEmail = response['data']['user']['email'] ?? 'Unknown';
          String profileImage = response['data']['user']['profileImage'] ?? 'Unknown';

          print('User profile updated successfully');
          showChangedDialog();
        }
      }).catchError((error) {
        print('Failed to update user profile: $error');
        setState(() {
          _isLoading = false;
        });
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
                    builder: (context) => HomePage(),
                  ),
                );
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
  String toString() {
    return 'User(name: $name, email: $email, password: $password, userId: $userId, userStatus: $userStatus)';
  }
}
