import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firstapp/pages/EventAnalyticsTab.dart';
import 'package:firstapp/pages/SecondaryAnalyticsTab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firstapp/widgets/stats_card.dart';

//Pantone Colors
const Color pantone159 = Color(0xFFF67F46); // humanities
const Color pantone2718 = Color(0xFF2671AF); //health science
const Color pantone201 = Color(0xFF9F1A35); // law
const Color pantone377 = Color(0xFF7C9F2D); //NAS
class AnalyticsPage extends StatelessWidget {
  final String baseUrl = 'http://localhost:8080/query';

  Future<List<Map<String, dynamic>>> fetchEventData(String viewName) async {
    final encodedViewName = Uri.encodeComponent(viewName);
    final query = 'SELECT * FROM `whatsonup-analytics.analytics_455402105.$encodedViewName`';
    final encodedQuery = Uri.encodeComponent(query);
    final url = '$baseUrl?query=$encodedQuery';

    // Print the complete URL for debugging
    print('Fetching data from URL: $url');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load event data: ${response.statusCode}');
    }
  }

 /* String extractNumber(String fieldValue) {
    final RegExp regex = RegExp(r'value=(\d+)');
    final match = regex.firstMatch(fieldValue);
    return match != null ? match.group(1) ?? '0' : '0';
  }*/
  String extractValue(String fieldValue) {
    final RegExp regex = RegExp(r'value=(.+?)(?:\}|$)');
    final match = regex.firstMatch(fieldValue);
    return match != null ? match.group(1) ?? '' : '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
          children: [
    // Help Menu Accesses
    Expanded(
    child: FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchEventData('help_menu_view'),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    } else
    {
    final helpMenuCount = snapshot.data?.isNotEmpty == true
    ? extractValue(snapshot.data![0]['help_menu_access_count'])
        : '0';
    return StatsCard(
    title: 'Help Menu Accesses',
    count: helpMenuCount.toString(),
    color: pantone159,
    );
    }
    },
    ),
        ),
        SizedBox(width: 16),
    // Active Users
        Expanded(
    child: FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchEventData('active_users_view'),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    } else {
    final activeUsers = snapshot.data?.isNotEmpty == true
    ? extractValue(snapshot.data![0]['active_users'])
        : '0';

    return StatsCard(
    title: 'Active Users',
    count: activeUsers.toString(),
    color: pantone2718,
    );
    }
    },
    ),
        ),
    ],
      ),
         SizedBox(height: 16),
      //new vs returning users
        Row(
          children: [
        Expanded(
          child:  FutureBuilder<List<Map<String, dynamic>>>(
             future: fetchEventData('new_vs_returning_users_view'),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(child: CircularProgressIndicator());
               } else if (snapshot.hasError) {
                 return Center(child: Text('Error: ${snapshot.error}'));
               } else {
                 String newUserCount = '0';
                 String returningUserCount = '0';

                 for (var data in snapshot.data!) {
                   final eventName = data['event_name'] as String;
                   final userCount = extractValue(data['user_count'].toString());

                   if (eventName.contains('first_open')) {
                     newUserCount = userCount;
                   } else if (eventName.contains('session_start')) {
                     returningUserCount = userCount;
                   }
                 }

                 return Row(
                   children: [
                     Expanded(
                 child:StatsCard(
                       title: 'New Users',
                       count: newUserCount,
                       color: pantone201,
                     ),
                     ),
                     SizedBox(width:16),
                     Expanded(
                       child:StatsCard(
                       title: 'Returning Users',
                       count: returningUserCount,
                       color: pantone377,
                     ),
                     ),
                   ],
                 );
               }
             },
           ),
        ),
      ],
        ),
      SizedBox(height: 16),
    // User Location

           FutureBuilder<List<Map<String, dynamic>>>(
             future: fetchEventData('user_location_view'),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(child: CircularProgressIndicator());
               } else if (snapshot.hasError) {
                 return Center(child: Text('Error: ${snapshot.error}'));
               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                 return Center(child: Text('No data available'));
               } else {
                 final List<Map<String, dynamic>> data = snapshot.data!;

                 // Transform the response data to match the expected format
                 return Container(
                   height: 300, // Adjusted height for better display
                   padding: const EdgeInsets.all(16.0),
                   child: SfCircularChart(
                     title: ChartTitle(text: 'User Locations by City'),
                     legend: Legend(isVisible: true),
                     series: <PieSeries<Map<String, dynamic>, String>>[
                       PieSeries<Map<String, dynamic>, String>(
                         dataSource: data,
                         xValueMapper: (data, _) => data['city']?.replaceAll('FieldValue{attribute=PRIMITIVE, value=', '').replaceAll('}', '') ?? 'Unknown City',
                         yValueMapper: (data, _) => int.tryParse(data['user_count']?.replaceAll('FieldValue{attribute=PRIMITIVE, value=', '').replaceAll('}', '') ?? '0') ?? 0,
                         dataLabelSettings: DataLabelSettings(isVisible: true),
                       ),
                     ],
                   ),
                 );
               }
             },
           ),
           SizedBox(height: 16),
           // Detailed Event Clicks

           FutureBuilder<List<Map<String, dynamic>>>(
             future: fetchEventData('detailed_event_clicks_view'),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(child: CircularProgressIndicator());
               } else if (snapshot.hasError) {
                 return Center(child: Text('Error: ${snapshot.error}'));
               } else {
                 final data = snapshot.data ?? [];
                 return Container(
                   height: 400,
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
               child: Align(
               alignment: Alignment.topLeft, // Align chart to the start
               child: SizedBox(
                      width: MediaQuery.of(context).size.width, // Take full width
                      child:SfCartesianChart(
                        title: ChartTitle(text: 'Detailed Event Clicks'),
                     primaryXAxis: CategoryAxis(
                       labelRotation: 45,
                       labelAlignment: LabelAlignment.start,
                     ),
                     primaryYAxis: NumericAxis(
                       labelFormat: '{value}',
                     ),
                     series: <CartesianSeries>[
                       BarSeries<Map<String, dynamic>, String>(
                         dataSource: data,
                         xValueMapper: (data, _) => extractValue(data['event_name'].toString()),
                         yValueMapper: (data, _) => int.tryParse(extractValue(data['click_count'].toString())) ?? 0,
                         name: 'Click Count',
                         dataLabelSettings: DataLabelSettings(isVisible: true),
                         color: Colors.blue,
                       ),
                     ],
                     tooltipBehavior: TooltipBehavior(enable: true),
                   ),
                    ),
               ),
                 );
               }
             },
           ),
           SizedBox(height: 16),
           FutureBuilder<List<Map<String, dynamic>>>(
             future: fetchEventData('event_cancellations_view'),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(child: CircularProgressIndicator());
               } else if (snapshot.hasError) {
                 return Center(child: Text('Error: ${snapshot.error}'));
               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                 // Show an annotation in the chart itself if there is no data
                 return Container(
                   height: 400,
                   child: SfCartesianChart(
                     primaryXAxis: CategoryAxis(),
                     primaryYAxis: NumericAxis(),
                     annotations: <CartesianChartAnnotation>[
                       CartesianChartAnnotation(
                         widget:Container(
                     child: const Text(
                           'No event cancellation data available',
                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: pantone201),
                         ),
),                       coordinateUnit: CoordinateUnit.logicalPixel,
                         x: 200,
                         y: 200,
                       ),
                     ],
                   ),
                 );
               } else {
                 final data = snapshot.data ?? [];
                 return Container(
                   height: 400,
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
                   child: SfCartesianChart(
                     title: ChartTitle(text: 'Event Cancellations'),
                     primaryXAxis: CategoryAxis(
                       labelRotation: 45,
                       labelAlignment: LabelAlignment.start,
                     ),
                     primaryYAxis: NumericAxis(
                       labelFormat: '{value}',
                     ),
                     series: <CartesianSeries>[
                       BarSeries<Map<String, dynamic>, String>(
                         dataSource: data,
                         xValueMapper: (data, _) => extractValue(data['event_name'].toString()),
                         yValueMapper: (data, _) => int.tryParse(extractValue(data['cancellations'].toString())) ?? 0,
                         name: 'Event Cancellations',
                         dataLabelSettings: DataLabelSettings(isVisible: true),
                         color: pantone377, // Use red color to symbolize cancellations
                       ),
                     ],
                     tooltipBehavior: TooltipBehavior(enable: true),
                   ),
                 );
               }
             },
           ),


           FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchEventData('average_session_time_view'),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      return Container(
          height: 300, // Adjusted height for better display
          padding: const EdgeInsets.all(16.0),
      child:  SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
      labelFormat: '{value}',
      ),
    series: <CartesianSeries>[
      ColumnSeries<Map<String, dynamic>, String>(
      dataSource: snapshot.data ?? [],
      xValueMapper: (data, _) => data['event_name'].toString(),
      yValueMapper: (data, _) => int.tryParse(extractValue(data['cancellation_count'].toString())) ?? 0,
      name: 'Cancellations',
      color: Colors.red,
      ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
      ),
      );
    }
    },
    ),
    // Sign-in Counts
    FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchEventData('sign_in_counts_view'),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    } else {
    return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: <CartesianSeries>[
    ColumnSeries<Map<String, dynamic>, String>(
    dataSource: snapshot.data!,
    xValueMapper: (data, _) => 'Sign-ins',
    yValueMapper: (data, _) => int.tryParse(data['sign_ins'].toString()) ?? 0,
    name: 'Sign-ins',
    dataLabelSettings: DataLabelSettings(isVisible: true),
    ),
    ],
    );
    }
    },
    ),

      ],
        )
    )
    );

  }
}