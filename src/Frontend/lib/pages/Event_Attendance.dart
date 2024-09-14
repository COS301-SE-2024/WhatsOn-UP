import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../widgets/event_card.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../services/EventService.dart';
import 'package:file_picker/file_picker.dart';

class EventAttendance extends StatefulWidget {
  Event event;
  EventAttendance({super.key, required this.event});

  @override
  State<EventAttendance> createState() => _EventAttendanceState();
}

class _EventAttendanceState extends State<EventAttendance> {
  late List<Attendee> filteredAttendees;
  TextEditingController searchController = TextEditingController();
  Map<String, bool?> attendanceStatuses = {};
  bool isLoading = true;
  EventService eventService = EventService(Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    filteredAttendees = widget.event.attendees;
    searchController.addListener(filterAttendees);
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final data = await eventService.fetchAttendanceData(widget.event.id,user!.id );

      setState(() {
        for (var record in data) {
          attendanceStatuses[record['user_id']] = record['attended'];
        }
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching attendance data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterAttendees() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredAttendees = widget.event.attendees
          .where((attendee) => attendee.fullName.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> exportToCSV() async {
    List<List<dynamic>> rows = [];
    rows.add(["Full Name", "Attendance Status"]);
    for (var attendee in filteredAttendees) {
      String attendanceStatus = 'Unknown';
      if (attendanceStatuses.containsKey(attendee.userId)) {
        attendanceStatus = attendanceStatuses[attendee.userId] == true
            ? 'Present'
            : attendanceStatuses[attendee.userId] == false
            ? 'Absent'
            : 'Unknown';
      }
      rows.add([attendee.fullName, attendanceStatus]);
    }

    String csvData = const ListToCsvConverter().convert(rows);


    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/attendance_${widget.event.nameOfEvent}.csv';


    final file = File(path);
    await file.writeAsString(csvData);


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance list exported as CSV to $path'),
        duration: Duration(seconds: 3),
      ),
    );
  }
  Future<void> importFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final bytes = result.files.single.bytes;
      final csvString = utf8.decode(bytes!);
      final csvData = CsvToListConverter().convert(csvString);

      if (csvData.isNotEmpty) {
        // Skipping header row
        for (var i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          final fullName = row[0] as String;
          final attendanceStatus = row[1] as String;

          // Find the attendee and update their status
          final attendee = widget.event.attendees
              .firstWhere(
                (attendee) => attendee.fullName == fullName,
            orElse: () => Attendee(userId: '', fullName: '', profileImage: '', role: Role(id: 0, name: ''))
          );

          if (attendee != null) {
            bool? status = attendanceStatus == 'Present'
                ? true
                : attendanceStatus == 'Absent' ? false : null;

            setState(() {
              attendanceStatuses[attendee.userId] = status;
            });

            // Optionally, send updated statuses to the backend
            try {
              await eventService.updateAttendanceStatus(
                widget.event.id,
                attendee.userId,
                status,
              );
            } catch (e) {
              // Handle errors, maybe show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update attendance for $fullName'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          } else {
            // Handle case where no attendee is found
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No attendee found with the name $fullName'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV file imported successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.nameOfEvent),
      ),
      body: isLoading
          ? SpinKitPianoWave(
        color: const Color.fromARGB(255, 149, 137, 74),
        size: 50.0,
      ): Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredAttendees.isEmpty
                ? Center(
                    child: Text("No attendees found."),
                  )
                : ListView.builder(
                    itemCount: filteredAttendees.length,
                    itemBuilder: (context, index) {
                      var attendee = filteredAttendees[index];
                      var attendanceStatus = attendanceStatuses[attendee.userId];

                      Color statusColor;
                      String statusText;

                      if (attendanceStatus == true) {
                        statusColor = Colors.green;
                        statusText = "Present";
                      } else if (attendanceStatus == false) {
                        statusColor = Colors.red;
                        statusText = "Absent";
                      } else {
                        statusColor = Colors.grey;
                        statusText = "Unknown";
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              filteredAttendees[index].profileImage != null &&
                                      filteredAttendees[index]
                                          .profileImage
                                          .isNotEmpty
                                  ? NetworkImage(
                                      filteredAttendees[index].profileImage)
                                  : AssetImage('assets/images/user.png'),
                          radius: 20,
                        ),
                        title: Center(
                          child: Text(filteredAttendees[index].fullName),
                        ),
                      trailing: TextButton(
                      onPressed: () {
                      // Optional: Add action for the button
                      },
                      child: Text(
                      statusText,
                      style: TextStyle(color: statusColor),
                      ),
                      ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
      FloatingActionButton(
        onPressed: exportToCSV,
        child: Icon(Icons.download),
        tooltip: 'Export to CSV',
      ),

      SizedBox(width: 16),
      FloatingActionButton(
        onPressed: importFromCSV,
        child: Icon(Icons.upload),
        tooltip: 'Import from CSV',
      ),
      ],
    ),
    );
  }
}
