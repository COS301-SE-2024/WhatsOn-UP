
import 'package:firstapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/application_event.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firstapp/pages/editProfile_page.dart';
import 'dart:typed_data';
class ProfilePage extends StatelessWidget {
  // final String profileImageUrl;
  final String userName;
  final String userEmail;
  final String userId;
  final String role;
  final Uint8List? profileImage;
  //final String userId;
  const ProfilePage({
  // required this.profileImageUrl,
   required this.userName,
  required this.userEmail,
    required this.userId,
  required this.role,
    required this.profileImage,
    //required this.userId;
  }); // Constructor to initialize final variable

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text('Profile'),
        actions: [
          // onPressed:(){}, Icon(LineAwesomeIcons.moon)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: profileImage!=null
                      ? MemoryImage(profileImage!)
                      : AssetImage('http/example-image') as ImageProvider,
                  radius: 24.0,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                userName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(height: 8),
              Text(
                userEmail,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditprofilePage( //editProfile
                        //profileImageUrl: profileImageUrl,
                        userName: userName,
                        userEmail: userEmail,
                        userId: userId,
                        role: role,
                        profileImage:  profileImage,
                       // UserId:userId,
                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder()
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
               Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColour),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                   
                    text: 'Create event application',
                    onTap: () {
                     Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ApplicationEvent(
              //profileImageUrl: profileImageUrl,
              userName: userName,
              userEmail: userEmail,
              userId: userId,
              role: role,
                profileImage:  profileImage,)),
          );
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    
                    text: 'Notifications',
                    onTap: () {
                      // Handle notifications tap
                    },
                  ),
                  
                  _buildDivider(),
                  _buildProfileOption(
                    
                    text: 'Security',
                    onTap: () {
                      // Handle account tap
                    },
                  ),
                  _buildDivider(),
                  _buildProfileOption(
                    text: 'Logout',
                    onTap: () {
                      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
                    },
                  ),
                  
                ],
              ),
            ),


            ],
          ),
        ),
      ),
    );
  }


   Widget _buildProfileOption({
  
    required String text,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      
      title: Text(text),
      trailing: trailing != null
          ? SizedBox(
              width: 100,
              child: trailing,
            )
          : const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }


}
