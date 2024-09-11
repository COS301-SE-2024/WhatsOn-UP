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
class EventAnalyticsTab extends StatelessWidget {
  final String baseUrl = 'http://localhost:8080/query';

  Future<List<Map<String, dynamic>>> fetchEventData(String viewName) async {
    final response = await http.get(
      Uri.parse('$baseUrl?query=SELECT%20*%20FROM%20`whatsonup-analytics.analytics_455402105.$viewName`'),
    );
    print(response);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load event data: ${response.statusCode}');
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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchEventData('help_menu_view'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final helpMenuCount = snapshot.data?.isNotEmpty == true
                    ? extractNumber(snapshot.data![0]['help_menu_access_count'])
                    : '0';
                return StatsCard(
                  title: 'Help Menu Accesses',
                  count: helpMenuCount.toString(),
                  color: Colors.orange,
                );
              }
            },
          ),
          // Detailed Event Clicks
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchEventData('detailed_event_clicks_view'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: snapshot.data!,
                      xValueMapper: (data, _) => data['event_name'] as String,
                      yValueMapper: (data, _) => int.tryParse(data['clicks'].toString()) ??0,
                      name: 'Event Clicks',
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                );
              }
            },
          ),
          // Event Cancellations
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchEventData('event_cancellations_view'),
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
                      xValueMapper: (data, _) => data['event_name'] as String,
                      yValueMapper: (data, _) => int.tryParse(data['cancellations'].toString()) ?? 0,
                      name: 'Event Cancellations',
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                );
              }
            },
          ),

        ],
      ),
    );
  }
}
