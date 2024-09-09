import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/AnalyticsService.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/AnalyticsService.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firstapp/pages/EventAnalyticsTab.dart';
import 'package:firstapp/pages/SecondaryAnalyticsTab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firstapp/widgets/stats_card.dart';

class SecondaryAnalyticsTab extends StatelessWidget {
  final String baseUrl = 'http://localhost:8080/query';

  Future<List<Map<String, dynamic>>> fetchSecondaryData(String viewName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?query=SELECT%20*%20FROM%20`whatsonup-analytics.analytics_455402105.$viewName`'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load secondary data');
    }
  }
  String extractNumber(String fieldValue) {
    final RegExp regex = RegExp(r'value=(\d+)');
    final match = regex.firstMatch(fieldValue);
    return match != null ? match.group(1) ?? '0' : '0';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Active Users
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSecondaryData('active_users_view'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
               final activeUsers = snapshot.data?.isNotEmpty == true
                    ? extractNumber(snapshot.data![0]['active_users'])
                    : '0';

                return StatsCard(
                  title: 'Active Users',
                  count: activeUsers.toString(),
                  color: Colors.lightBlue,
                );
              }
            },
          ),
        //new vs returning users
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSecondaryData('new_vs_returning_users_view'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final newVsReturningUsers = snapshot.data?.isNotEmpty == true ? snapshot.data![0]['new_vs_returning_users'] : '0';
                return StatsCard(
                  title: 'New vs Returning Users',
                  count: newVsReturningUsers.toString(),
                  color: Colors.green,
                );
              }
            },
          ),
          // Average Session Time
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSecondaryData('average_session_time_view'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: snapshot.data!,
                      xValueMapper: (data, _) => 'Average Session Time',
                      yValueMapper: (data, _) => double.tryParse(data['avg_session_time'].toString() ) ?? 0.0,
                      name: 'Session Time',
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                );
              }
            },
          ),
          // Sign-in Counts
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSecondaryData('sign_in_counts_view'),
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
          // User Location
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchSecondaryData('user_location_view'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                final List<PieSeries<Map<String, dynamic>, String>> pieSeries = [
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: snapshot.data!,
                    xValueMapper: (data, _) => data['location'] as String,
                    yValueMapper: (data, _) => int.tryParse(data['user_count'].toString()) ?? 0,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ];

                return SfCircularChart(
                  title: ChartTitle(text: 'User Locations'),
                  legend: Legend(isVisible: true),
                  series: pieSeries,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}