
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:firstapp/pages/login_page.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:firstapp/services/EditprofileServices.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
class EditprofilePage extends StatefulWidget {
  // final String profileImageUrl;
  final String userName;
  final String userEmail;
  // final String role;
  const EditprofilePage(
      {
        Key? key,
        // required this.profileImageUrl,
        required this.userName,
        required this.userEmail,
        //  required this.role;
      }
      ): super(key: key);
  @override
  _EditprofilePage createState() => _EditprofilePage();

}

class _EditprofilePage extends State<EditprofilePage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool rememberUser = false;
  String adjustedName='';
  String adjustedPassword='';
  String adjustedEmail='';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: const Icon(LineAwesomeIcons.angle_left_solid)),
          title: Text('Edit Profile'),

        ),
        backgroundColor: Colors.transparent,
          body: _buildBottom()),

        );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final theme = Theme.of(context);
    final loginTextColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildInputField(
            nameController,
            label: widget.userName,
            icon: Icons.person,

          ),
          const SizedBox(height: 30),
          _buildInputField(
            emailController,
            label: widget.userEmail,
            icon: Icons.email,

            validator: (value) {
              if (value != null && !value.isEmpty) {
                final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!regex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
              }
              return null; // If value is empty or valid
            },




          ),
          const SizedBox(height: 30),
          _buildInputField(
            passwordController,
            label: "Password",
            icon: Icons.lock,
            isPassword: true,
            validator: (value) {
              if (value != null && !value.isEmpty) {
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
              }

                return null;
            },
          ),
          const SizedBox(height: 30),
          _buildInputField(
            confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock,
            isPassword: true,
            validator: (value) {
              if (value != null && !value.isEmpty) {
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          SizedBox(

            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // backend processing-user data will be saved here
                  if(!nameController.text.isEmpty)
                  {
                      adjustedName=nameController.text;
                  }
                  else if(nameController.text.isEmpty){
                    adjustedName=widget.userName;
                  }
                  else if(!emailController.text.isEmpty){
                    adjustedEmail=emailController.text;
                  }
                  else if(emailController.text.isEmpty){
                    adjustedEmail=widget.userEmail;
                  }
                  else if(!passwordController.text.isEmpty){
                    adjustedPassword=passwordController.text;
                  }
                  else if(passwordController.text.isEmpty){
                    //find password by id
                  }
                  final user = User(
                    name: adjustedName,
                    email: adjustedEmail,
                    password:adjustedPassword,
                  );
                  print(user);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(
                      // profileImageUrl: widget.profileImageUrl,
                      userName: widget.userName,
                      userEmail: widget.userEmail,
                      // role: widget.role,
                      //userId: widget.userId,
                    ),),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'confirm',
                // style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                style: TextStyle(color: loginTextColour),
              ),
            ),
          ),








        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, {
        required String label,
        required IconData icon,
        bool isPassword = false,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      obscureText: isPassword,
      validator: validator,
    );
  }
  Future<void> _EditUser() async {
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        // backend processing-user data will be saved here
        if(!nameController.text.isEmpty)
        {
          adjustedName=nameController.text;
        }
        else if(nameController.text.isEmpty){
          adjustedName=widget.userName;
        }
        else if(!emailController.text.isEmpty){
          adjustedEmail=emailController.text;
        }
        else if(emailController.text.isEmpty){
          adjustedEmail=widget.userEmail;
        }
        else if(!passwordController.text.isEmpty){
          adjustedPassword=passwordController.text;
        }
        else if(passwordController.text.isEmpty){
          //find password by id
        }
        final user = User(
          name: adjustedName,
          email: adjustedEmail,
          password:adjustedPassword,
        );
        print(user);
        postChangeUser(user.name,user.email,user.password).then((response) {
          if (response['error'] != null) {

            print('An error occurred: ${response['error']}');
          } else {
            String fullName = response['body']['user']['fullName']?? 'Unknown';
            String userEmail = response['body']['user']['email'] ?? 'Unknown';
            //String UserId=response['body']['user']['id']?? 'Unknown';
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(
                userName:  fullName,
                userEmail: userEmail,
                // userId:UserId
              )),
            );
            print('Edit sucessful');
          }
        });

      }
    };
  }
}

class User {
  final String name;
  final String email;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password)';
  }
}
