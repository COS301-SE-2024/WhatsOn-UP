import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/schemas/notification_schemas.dart';
import 'package:firstapp/services/LocalNotifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:json_schema/json_schema.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../pages/notifications.dart';
import '../providers/notification_providers.dart';

import 'api.dart';

class SocketService {
  late IO.Socket socket;
  final notificationProvider _notificationProvider;
  final BuildContext context;
  SocketService(String url, this._notificationProvider,String userId,this.context) {
    // _notificationProvider=Provider.of<notificationProvider>(context, listen: true);
    final headers = {
      'token': 'Bearer $userId',
    };

    print(userId);

    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'token': userId},
    });

    // Add event listeners
    socket.on('connect', (_) {
      print('Connected: ${socket.id}');
    });

    socket.on('disconnect', (_) {
      print('Disconnected');
    });

    socket.on('notification', (data) {
      print('Event received: $data');

      final schema = JsonSchema.create(NOTIFICATION_SOCKET_SCHEMA);
      final result = schema.validate(data);

      if(result.isValid){
        _notificationProvider.refreshNotifications(userId);
        LocalNotifications.showNotification(title: data['data']['notification_types']['name'], body: data['data']['message'], payload: "");
      }
      else{
        throw Exception(result.errors);
      }


    });
    socket.on('error', (error) {
      print('Error: $error');
    });
  }
  void refreshNotifications(String userId) {
    _notificationProvider.refreshNotifications(userId);
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
  void sendMessage(String event, dynamic message) {
    socket.emit(event, message);
  }




  void dispose() {
    socket.dispose();
  }
}

