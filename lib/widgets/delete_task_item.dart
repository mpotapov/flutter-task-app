import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';

class DeleteTaskItem extends StatelessWidget {
  final _taskId;

  DeleteTaskItem(this._taskId);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        showDialog(
          context: context,
          child: AlertDialog(
            title: const Text('Warning'),
            content: const Text('Are you sure you want to delete tesk?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: const Text('Delete'),
                onPressed: () async {
                  try {
                    await Provider.of<Tasks>(context, listen: false)
                        .deleteTask(_taskId);
                    Navigator.of(context).pop();
                  } catch (err) {
                    Navigator.of(context).pop();
                    Scaffold.of(context).removeCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Something went wrong!'),
                    ));
                  }
                },
              ),
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
