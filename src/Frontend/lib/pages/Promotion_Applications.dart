import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events_providers.dart';
import '../providers/user_provider.dart';
import '../widgets/event_card.dart';
import 'Promotion_Processing.dart';
import 'Event_Attendance.dart';
import 'editProfile_page.dart';

class Generaleventapplications extends StatefulWidget {
  const Generaleventapplications({super.key});

  @override
  State<Generaleventapplications> createState() => _GeneraleventapplicationsState();
}

class _GeneraleventapplicationsState extends State<Generaleventapplications> {
  late final _generalUserEvents;

  @override
  void initState() {
    super.initState();
    userProvider userP = Provider.of< userProvider>(context, listen: false);

    _generalUserEvents = userP.generalUserEvents;

  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColour = theme.colorScheme.onSurface;
    final borderColour = theme.colorScheme.secondary;

    return Scaffold(
        appBar: AppBar(
          title: const Text('General User Applications'),
        ),
        body: FutureBuilder<List<User>>(
          future: _generalUserEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occurred: ${snapshot.error}'),
              );
            } else {
              userProvider userP = Provider.of<userProvider>(context, listen: false);
              var users = snapshot.data!;

              return ListView.separated(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: users[index].profileImage!.isNotEmpty
                          ? NetworkImage(users[index].profileImage!)
                          : const AssetImage('assets/images/user.png'),
                      radius: 20,
                    ),
                    title: Center(
                      child: Text(users[index].name),
                    ),
                    trailing: statusbutton(users[index].userStatus),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventHost(user: users[index]),
                        ),
                      );
                    },
                  );

                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              );
            }
          },
        ));

  }
  Widget statusbutton(String? status) {
    Color statusColor;
    switch (status) {
      case 'Accepted':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.lightBlueAccent;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return StatusButton(status: status, color: statusColor);
  }
}
class StatusButton extends StatelessWidget {
  final String? status;
  final Color color;

  StatusButton({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        status!,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}