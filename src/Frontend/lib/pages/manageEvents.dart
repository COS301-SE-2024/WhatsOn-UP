
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firstapp/pages/application_event.dart';
import 'ManageGeneralApplicationsTabs.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/eventManagement_category.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../services/EventService.dart';
import '../widgets/Pastevents.dart';
class ManageEvents extends StatefulWidget {
  final SupabaseClient supabaseClient;

  const ManageEvents({
    super.key,
    required this.supabaseClient,
  });

  @override
  _ManageEventsState createState() => _ManageEventsState();
}

class _ManageEventsState extends State<ManageEvents> {
  bool _isLoading = false;
  String Admin = 'ADMIN';
  String Host = 'HOST';
  String? _selectedOption;
  var _hoveredIndex;
  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textColour = theme.colorScheme.onSurface;
    userProvider userP = Provider.of<userProvider>(context);
    SupabaseClient supabaseClient = widget.supabaseClient;

    final List<Map<String, dynamic>>  options = [
      {'text': userP.role == Admin ? 'All Events' : 'My Events', 'route': 'EventManagementCategory', 'icon': Icons.event},
      {'text': 'Past Events', 'route': 'Pastevents', 'icon': Icons.history},
      {'text': 'Create Event', 'route': 'ApplicationEvent', 'icon': Icons.add},
      if (userP.role == Admin) {'text': 'General user Host Applications', 'route': 'GeneralEventApplications', 'icon': Icons.group},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: const Text('Manage Events'),
      ),
      body: _isLoading
          ? const Center(
        child: SpinKitPianoWave(
          color: Color.fromARGB(255, 149, 137, 74),
          size: 50.0,
        ),
      )

      :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final IconData icon = option['icon'] as IconData;
                  final isSelected = _selectedOption == option['text'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOption = option['text'];
                      });
                      _navigateToRoute(option['route']!, context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromARGB(255, 149, 137, 74)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color.fromARGB(255, 149, 137, 74),
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: 50.0,
                            color: textColour,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            option['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColour,
                            ),
                          ),





                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

      ),
    );
  }

  void _navigateToRoute(String route, BuildContext context) {
    switch (route) {
      case 'EventManagementCategory':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventmanagementCategory(supabaseClient: widget.supabaseClient)),
        );
      case 'Pastevents':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pastevents(
              eventService: EventService(widget.supabaseClient),
              supabaseClient: widget.supabaseClient,
            ),
          ),
        );
      case 'ApplicationEvent':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ApplicationEvent()),
        );
      case 'GeneralEventApplications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TabGeneral()),
        );
      default:
        break;
    }
  }
}
