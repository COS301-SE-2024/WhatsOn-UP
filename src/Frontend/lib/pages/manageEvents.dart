import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firstapp/pages/application_event.dart';


import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/eventManagement_category.dart';

class ManageEvents extends StatelessWidget {
  ManageEvents({Key? key}) : super(key: key);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text('Manage Events'),
      ),
      body: _isLoading
          ? Center(
        child: SpinKitPianoWave(
          color: const Color.fromARGB(255, 149, 137, 74),
          size: 50.0,
        ),
      )
          : Column(
        children: [
          _buildProfileOption(
            text: userP.role == 'ADMIN' ? 'All Events' : 'My Events',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventmanagementCategory()),
              );
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            text: 'Past Events',
            onTap: () {

            },
          ),
          _buildDivider(),
          _buildProfileOption(
            text: 'Create Event',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApplicationEvent(

                )),
              );
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            text: 'Attendees',
            onTap: () {

            },
          ),
          _buildDivider(),
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