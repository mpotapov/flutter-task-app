import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../widgets/app_drawer.dart';

class RemindersScreen extends StatefulWidget {
  static String routeName = '/reminders';

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<PendingNotificationRequest> _notifications = [];
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<bool> _fetchNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _notifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return true;
  }

  String createSubtitle(var notification) {
    return '${notification['day']}.${notification['month']}.${notification['year']} ${notification['hour']}:${notification['minute']}';
  }

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notifications'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _fetchNotifications(),
        builder: (_, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.all(_deviceData.size.width * 0.025),
                    child: ListView.builder(
                      itemCount: _notifications.length,
                      itemBuilder: (_, index) => Card(
                        child: ListTile(
                          title: Text(_notifications.elementAt(index).body),
                          subtitle: Text(createSubtitle(json.decode(
                              _notifications.elementAt(index).payload))),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await _flutterLocalNotificationsPlugin
                                  .cancel(_notifications.elementAt(index).id);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
