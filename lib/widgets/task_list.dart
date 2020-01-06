import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mixins/error_handler.dart';

import '../models/task.dart';

import '../providers/tasks.dart';

import '../screens/task_details_screen.dart';

import 'task_list_item.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> with ErrorHandler {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<Tasks>(context, listen: false).fetchTasks().catchError(
          (err) => showError(context, err),
        );
    _scrollController.addListener(_scrollControllerListener);
    super.initState();
  }

  void _scrollControllerListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      Provider.of<Tasks>(context, listen: false).fetchNewPage().catchError(
            (err) => showError(context, err),
          );
      ;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> _tasks = Provider.of<Tasks>(context).items;
    final int _taskCount = Provider.of<Tasks>(context).meta['count'];
    final _deviceData = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        controller: _tasks.length > 6 ? _scrollController : null,
        itemCount: _tasks.length + 1,
        itemBuilder: (ctx, item) {
          if (item == _tasks.length && _tasks.length != _taskCount) {
            return CupertinoActivityIndicator();
          } else if (item == _tasks.length && _taskCount == _tasks.length) {
            return Container(
              height: _deviceData.size.height * 0.1,
            );
          }
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(TaskDetailsScreen.routeName,
                  arguments: _tasks[item].id);
            },
            child: TaskListItem(_tasks[item]),
          );
        },
      ),
    );
  }
}
