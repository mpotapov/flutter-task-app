import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'delete_task_item.dart';

class TaskListItem extends StatelessWidget {
  final _task;

  TaskListItem(this._task);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_task.title),
        subtitle: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Row(
                children: [
                  const Text('Due to '),
                  Text(
                    '${DateFormat.yMd().format(_task.dueBy)}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _task.priority == 'Low'
                    ? const Icon(Icons.arrow_downward)
                    : _task.priority == 'High'
                        ? const Icon(Icons.arrow_upward)
                        : const Text(''),
                Text(
                  '${_task.priority}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
          ],
        ),
        trailing: DeleteTaskItem(_task.id),
      ),
    );
  }
}
