

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String profileImageUrl;

  const ProfilePage({required this.profileImageUrl}); // Constructor to initialize final variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 24.0,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){},
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
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                   
                    text: 'Create event application',
                    onTap: () {
                      // Handle profile tap
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
                      // Handle privacy tap
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
