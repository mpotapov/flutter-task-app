import 'package:flutter/material.dart';

import '../screens/task_list_screen.dart';
import '../screens/settings_screen.dart';

import './logout_button.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Task app',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_forward_ios),
            title: Text('Tasks'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  TaskListScreen.routeName, (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Reminders'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  SettingsScreen.routeName, (Route<dynamic> route) => false);
            },
          ),
          LogoutButton(),
        ],
      ),
    );
  }
}
