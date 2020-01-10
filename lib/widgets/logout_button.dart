import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Logout'),
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Log out'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Provider.of<Auth>(context, listen: false).logout();
                  }),
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
    );
  }
}
