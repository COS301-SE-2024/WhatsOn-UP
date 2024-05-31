import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildSettingsOption(
                    icon: Icons.person,
                    text: 'Profile',
                    onTap: () {
                      // Handle profile tap
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsOption(
                    icon: Icons.notifications,
                    text: 'Notifications',
                    onTap: () {
                      // Handle notifications tap
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
                  _buildDivider(),
                  _buildSettingsOption(
                    icon: Icons.vpn_key,
                    text: 'Account',
                    onTap: () {
                      // Handle account tap
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsOption(
                    icon: Icons.lock,
                    text: 'Privacy',
                    onTap: () {
                      // Handle privacy tap
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsOption(
                    icon: Icons.info,
                    text: 'About',
                    onTap: () {
                      // Handle about tap
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    return GestureDetector(
      onTap: () {
        setState(() {
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
  }
}
