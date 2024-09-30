import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import '../providers/user_provider.dart';
import 'notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
    // required this.profileImageUrl,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColour =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    userProvider userP = Provider.of<userProvider>(context, listen: false);
    String userRole = userP.role;

    return Scaffold(
      appBar: AppBar(
        title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColour,
              ),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColour),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: _buildSettings(userRole),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSettings(String userRole) {
    List<Widget> options = [
      _buildSettingsOption(
        icon: Icons.person,
        text: 'Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          );
        },
      ),
      _buildDivider(),
      _buildSettingsOption(
        icon: Icons.notifications,
        text: 'Notifications',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Notifications()),
          );
        },
      ),
      _buildDivider(),
      _buildSettingsOption(
        icon: Icons.brightness_6,
        text: 'Theme',
        trailing: _buildThemeToggle(),
        onTap: () {
          // Handle theme tap
        },
      ),
    ];

    if (userRole != "GUEST") {
      // Only display account option if user is not a guest
      options.add(_buildDivider());
      options.add(
        _buildSettingsOption(
          icon: Icons.vpn_key,
          text: 'Account',
          onTap: () {
            // Handle account tap
          },
        ),
      );
    }

    options.add(_buildDivider());
    options.add(
      _buildSettingsOption(
        icon: Icons.lock,
        text: 'Privacy',
        onTap: () {
          // Handle privacy tap
        },
      ),
    );

    options.add(_buildDivider());
    options.add(
      _buildSettingsOption(
        icon: Icons.info,
        text: 'Help',
        onTap: () {
          if(Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android)
          Navigator.of(context).pushNamed('/userManual');
        else
          _launchURL();
        },
      ),
    );

    return options;
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String text,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
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

  Widget _buildThemeToggle() {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        bool isLightTheme =
            themeNotifier.getTheme() == themeNotifier.lightTheme;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isLightTheme) {
                themeNotifier.setDarkMode();
              } else {
                themeNotifier.setLightMode();
              }
              isLightTheme = !isLightTheme;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isLightTheme ? Colors.grey[300] : Colors.black,
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: isLightTheme ? 0 : 30,
                      right: isLightTheme ? 30 : 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[700],
                        ),
                        child: Icon(
                          isLightTheme ? Icons.wb_sunny : Icons.nights_stay,
                          color: isLightTheme ? Colors.yellow : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: 8),
              // Text(isLightTheme ? 'Light' : 'Dark'),
            ],
          ),
        );
      },
    );
  }

  void _launchURL() async {
    const url = 'https://cos301-se-2024.github.io/WhatsOn-UP/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
