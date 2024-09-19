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
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

import 'package:excel/excel.dart';


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

    if (await Permission.storage
        .request()
        .isGranted) {
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
      final fileName = 'attendance_${widget.event.nameOfEvent}.csv';

      try {
        // Save file in the public Downloads directory using MediaStore API
        final directory = Directory('/storage/emulated/0/Download');
        final file = File(path.join(directory.path, fileName));

        await file.writeAsString(csvData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Attendance list exported as CSV to Downloads: $fileName'),
            duration: Duration(seconds: 5),
          ),
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Export Successful'),
              content: Text('The CSV file has been exported to Downloads. Would you like to open the folder now?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Open Folder'),
                  onPressed: () async {
                    final uri = Uri.parse('content://com.android.externalstorage.documents/document/primary%3ADownload');
                    final intent = AndroidIntent(
                      action: 'android.intent.action.VIEW',
                      data: uri.toString(),
                      type: 'vnd.android.document/directory',
                      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                    );
                    try {
                      await intent.launch();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unable to open folder: $e'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                    Navigator.of(context).pop(); },
                ),
                TextButton(
                  child: Text('Stay'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export CSV: $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is required to export CSV'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
        /*final intent = AndroidIntent(
          action: 'action_view',
          type: 'vnd.android.document/directory',
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } catch (e) {
        // Handle errors, if any
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export CSV: $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Permission not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is required to export CSV'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }*/
  Future<void> importFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx', 'tsv'],
    );

    if (result != null) {
      final file = result.files.single;
      final extension = file.extension?.toLowerCase();

      if (extension != null) {
        if (extension == 'csv' || extension == 'tsv') {
          // Handle CSV or TSV
          await _importCsvOrTsv(file);
        } else if (extension == 'xlsx' || extension == 'xls') {
          // Handle Excel files (.xls or .xlsx)
          await _importExcel(file);
        }  else {
          print('Unsupported file type');
        }
      }
    }
  }

  Future<void> _importCsvOrTsv(PlatformFile file) async {
    // Read CSV or TSV file content
    final bytes = file.bytes;
    if (bytes == null) return;

    final csvString = utf8.decode(bytes);
    final isTsv = file.extension == 'tsv';
    final csvData = CsvToListConverter(fieldDelimiter: isTsv ? '\t' : ',').convert(csvString);

    if (csvData.isNotEmpty) {
      // Skipping header row and processing data rows
      for (var i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        final fullName = row[0] as String;
        final attendanceStatus = row[1] as String;

        // Find the attendee and update their status
        final attendee = widget.event.attendees.firstWhere(
              (attendee) => attendee.fullName == fullName,
          orElse: () => Attendee(userId: '', fullName: '', profileImage: '', role: Role(id: 0, name: '')),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update attendance for $fullName'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
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
          content: Text('File imported successfully'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _importExcel(PlatformFile file) async {

    print("made it to excel func");
    var bytes = file.bytes;
    if (bytes == null) return;

    var excel = Excel.decodeBytes(bytes);

    // Loop through each sheet in the Excel file
    for (var table in excel.tables.keys) {
      List<List<dynamic>> rows = excel.tables[table]!.rows;

      // Skipping header row
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        final fullName = row[0] as String;
        final attendanceStatus = row[1] as String;
        print("WHAT WE READDDDDDDDDDDDDDDDD");
        print(fullName);
        print(attendanceStatus);
        // Similar logic as in the CSV/TSV import for finding the attendee and updating their status
        final attendee = widget.event.attendees.firstWhere(
              (attendee) => attendee.fullName == fullName,
          orElse: () => Attendee(userId: '', fullName: '', profileImage: '', role: Role(id: 0, name: '')),
        );

        if (attendee != null) {
          bool? status = attendanceStatus == 'Present'
              ? true
              : attendanceStatus == 'Absent' ? false : null;

          setState(() {
            attendanceStatuses[attendee.userId] = status;
          });

          try {
            await eventService.updateAttendanceStatus(
              widget.event.id,
              attendee.userId,
              status,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update attendance for $fullName'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No attendee found with the name $fullName'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel file imported successfully'),
        duration: Duration(seconds: 3),
      ),
    );
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
