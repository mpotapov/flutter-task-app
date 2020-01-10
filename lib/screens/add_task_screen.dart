import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mixins/error_handler.dart';

import '../providers/tasks.dart';

import '../models/task.dart';

import '../widgets/edit_task_fields.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-task';
  final _taskId;

  AddTaskScreen([this._taskId]);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> with ErrorHandler {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _task = {
    'title': null,
    'priority': null,
    'date': null,
    'time': null,
  };
  bool _saving = false;
  bool _loadingDataToApi = false;

  Task _createTaskInstanceFromMap(int taskId) {
    return Task(
      id: taskId,
      title: _task['title'],
      priority: _task['priority'],
      dueBy: DateTime(
        _task['date'].year,
        _task['date'].month,
        _task['date'].day,
        _task['time'].hour,
        _task['time'].minute,
      ),
    );
  }

  void _saveTask() async {
    setState(() {
      _saving = true;
    });
    if (_task['time'] == null ||
        _task['date'] == null ||
        !_formKey.currentState.validate() ||
        _task['priority'] == null) {
      _formKey.currentState.validate();
      showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Error!'),
          content: const Text('All fields are required!'),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } else {
      setState(() {
        _loadingDataToApi = true;
      });
      _formKey.currentState.save();
      if (widget._taskId != null) {
        await Provider.of<Tasks>(context, listen: false)
            .updateTask(
              widget._taskId,
              _createTaskInstanceFromMap(widget._taskId),
            )
            .then(Navigator.of(context).pop)
            .catchError(
              (err) => showError(context, err),
            );
      } else {
        await Provider.of<Tasks>(context, listen: false)
            .addTask(_createTaskInstanceFromMap(null))
            .then(Navigator.of(context).pop)
            .catchError(
              (err) => showError(context, err),
            );
      }
      setState(() {
        _loadingDataToApi = false;
      });
    }
  }

  @override
  void initState() {
    if (widget._taskId != null) {
      final taskFromDb = Provider.of<Tasks>(context, listen: false)
          .getTaskById(widget._taskId);
      _task['title'] = taskFromDb.title;
      _task['priority'] = taskFromDb.priority;
      _task['date'] = taskFromDb.dueBy;
      _task['time'] = TimeOfDay(
        hour: taskFromDb.dueBy.hour,
        minute: taskFromDb.dueBy.minute,
      );
    }
    super.initState();
  }

  void _setTaskState(String key, dynamic value) {
    setState(() {
      _task[key] = value;
    });
  }

  void _setTaskPriorityState(dynamic value) {
    setState(() {
      _task['priority'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveTask,
          )
        ],
      ),
      body: _loadingDataToApi
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(_deviceData.size.width * 0.025),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue:
                              _task['title'] == null ? '' : _task['title'],
                          validator: (title) {
                            if (title.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                          onSaved: (val) => _task['title'] = val,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).accentColor,
                      ),
                      EditTaskFields(
                        _task,
                        _saving,
                        _setTaskState,
                        _setTaskPriorityState,
                      )
                    ]),
                  ),
                ),
              ),
            ),
    );
  }
}
