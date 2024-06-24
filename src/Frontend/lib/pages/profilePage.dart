
import 'package:firstapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/application_event.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firstapp/pages/editProfile_page.dart';
import 'dart:typed_data';
import 'package:firstapp/pages/home_page.dart';
class ProfilePage extends  StatefulWidget {

  final String userName;
  final String userEmail;
  final String userId;
  final String role;
  Uint8List? profileImage;


  ProfilePage({
    Key? key,

    required this.userName,
    required this.userEmail,
    required this.userId,
    required this.role,
    required this.profileImage,

  }): super(key: key);



  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.profileImage != null
                            ? MemoryImage(widget.profileImage!)
                            : const AssetImage('http/example-image') as ImageProvider,
                        radius: 60.0,
                      ),
                      if (widget.role == 'ADMIN')
                        Positioned(
                          top:80,
                          right: 0,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,

                            ),
                            child: Image.asset('assets/images/adminBadge.png'),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 8),
                  Text(
                    widget.userEmail,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditprofilePage(
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                            userId: widget.userId,
                            role: widget.role,
                            profileImage: widget.profileImage,
                          )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
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
                        // _buildProfileOption(
                        //   text: 'Create event application',
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => ApplicationEvent(
                        //         userName: widget.userName,
                        //         userEmail: widget.userEmail,
                        //         userId: widget.userId,
                        //         role: widget.role,
                        //         profileImage: widget.profileImage,
                        //       )),
                        //     );
                        //   },
                        // ),
                        // _buildDivider(),
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
                            // Handle security tap
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
          Positioned(
            top: 40.0, // Adjust this value according to your needs
            left: 10.0, // Adjust this value according to your needs
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    userName: widget.userName,
                    userEmail: widget.userEmail,
                    userId: widget.userId,
                    role: widget.role,
                    profileImage: widget.profileImage,
                  )),
                );
              },
              icon: const Icon(LineAwesomeIcons.angle_left_solid),
            ),
          ),
        ],
      ),
    );
  }
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


