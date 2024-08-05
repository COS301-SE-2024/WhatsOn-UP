import 'package:firstapp/pages/supabase_login.dart';
import 'package:firstapp/pages/supabase_signup.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firstapp/pages/editProfile_page.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String ADMIN = 'ADMIN';

  @override
  Widget build(BuildContext context) {
    userProvider user = Provider.of<userProvider>(context);
    String userRole = user.role;
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
                        backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                            ? NetworkImage(user.profileImage!)
                            : const AssetImage('assets/images/user.png') as ImageProvider,
                        radius: 60.0,
                      ),
                      if (user.role == ADMIN)
                        Positioned(
                          top: 80,
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
                    userRole == "GUEST" ? "Guest User" : user.Fullname,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (userRole != "GUEST") ... [
                    const SizedBox(height: 20),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),             
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditprofilePage()),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey, width: 1),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ] else ... [
                    const SizedBox(height: 20),
                    Text(
                      "Create an account to access more features!",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SupabaseSignup ()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey, width: 1),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Already have an account? Log In'),
                    ),
                  ],
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  if (userRole != "GUEST") ... [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColour),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            text: 'Notifications',
                            onTap: () {
                              // Handle notifications
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            text: 'Security',
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/resetPassword');
                            },
                          ),
                          _buildDivider(),
                          _buildProfileOption(
                            text: 'Logout',
                            onTap: () {
                              final session = supabase.auth.currentSession;
                              if (session != null) {
                                supabase.auth.signOut();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SupabaseLogin()),
                              );
                            },
                          ),
                            _buildDivider(),
                            if (user.role!=ADMIN) ...[
                            _buildProfileOption(
                            text: 'Apply for Promotion',
                            onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                            '/PromotionForm');
                            },
                            ),
                            _buildDivider(),
                        ],
    ],
                      ),
                    ),
                  ] else ... [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColour),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            text: 'Limited Guest Features',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Limited Access'),
                                    content: Text('As a guest user, you have limited access to features. Sign up or log in to unlock full functionality!'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage(
                  //widget.profileImage,
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



// Future<void> _navigateToEditprofile(BuildContext context) async {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => EditprofilePage()),
//   );
// }
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