import 'package:flutter/material.dart';

import '../screens/add_task_screen.dart';

import '../widgets/task_details.dart';

class TaskDetailsScreen extends StatelessWidget {
  static const routeName = '/task-details';

  @override
  Widget build(BuildContext context) {
    final _taskId = ModalRoute.of(context).settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task details'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddTaskScreen(_taskId)));
            },
          )
        ],
      ),
      body: TaskDetails(),
    );
  }
}
