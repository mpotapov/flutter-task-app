import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mixins/error_handler.dart';

import '../screens/add_task_screen.dart';

import '../providers/tasks.dart';

import '../widgets/task_list.dart';
import '../widgets/app_drawer.dart';

class TaskListScreen extends StatelessWidget with ErrorHandler {
  static const routeName = '/task-list';

  @override
  Widget build(BuildContext context) {
    final _sortOptions = Provider.of<Tasks>(context).sortOptions;

    PopupMenuItem _popupMenuItem(String val, String itemName) {
      return PopupMenuItem(
        value: val,
        child: Text(itemName),
        textStyle: TextStyle(
            color: _sortOptions['sortBy'] == val ? Colors.black : Colors.grey),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            onSelected: (val) {
              Provider.of<Tasks>(context, listen: false).sortOptions = {
                'sortBy': val,
                'direction': _sortOptions['direction']
              };
              Provider.of<Tasks>(context, listen: false)
                  .fetchTasks()
                  .catchError(
                    (err) => showError(context, err),
                  );
            },
            itemBuilder: (_) => <PopupMenuEntry>[
              PopupMenuItem(
                child: const Text('Sort by:'),
                height: 1,
                enabled: false,
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              _popupMenuItem('title', 'Name'),
              _popupMenuItem('dueBy', 'Date'),
              _popupMenuItem('priority', 'Priority'),
            ],
          ),
          IconButton(
            icon: Icon(_sortOptions['direction'] == 'asc'
                ? Icons.arrow_upward
                : Icons.arrow_downward),
            onPressed: () {
              Provider.of<Tasks>(context, listen: false).sortOptions = {
                'sortBy': _sortOptions['sortBy'],
                'direction': _sortOptions['direction'] == 'asc' ? 'desc' : 'asc'
              };
              Provider.of<Tasks>(context, listen: false)
                  .fetchTasks()
                  .catchError(
                    (err) => showError(context, err),
                  );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Provider.of<Tasks>(context, listen: false)
              .fetchTasks()
              .catchError(
                (err) => showError(context, err),
              ),
          child: TaskList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddTaskScreen.routeName);
        },
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
