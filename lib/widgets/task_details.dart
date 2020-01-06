import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/tasks.dart';

class TaskDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);
    final _taskId = ModalRoute.of(context).settings.arguments as int;
    final _task =
        Provider.of<Tasks>(context, listen: false).getTaskById(_taskId);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: _deviceData.size.height * 0.02),
            padding: EdgeInsets.all(_deviceData.size.width * 0.03),
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${_task.title}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        '${DateFormat("EEEE d MMM, yyyy").format(_task.dueBy)}'),
                    Text('${DateFormat('h:mm a').format(_task.dueBy)}'),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceData.size.width * 0.03,
              vertical: _deviceData.size.height * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Priority'),
                Row(
                  children: <Widget>[
                    _task.priority == 'Low'
                        ? Icon(Icons.arrow_downward)
                        : _task.priority == 'High'
                            ? Icon(Icons.arrow_upward)
                            : const Text(''),
                    Text(
                      '${_task.priority}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
