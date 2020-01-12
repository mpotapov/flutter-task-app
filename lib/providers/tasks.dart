import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _items = [];
  Map<String, dynamic> _meta = {};
  Map<String, dynamic> _sortOptions = {};
  final _bearer;
  final _url = 'https://testapi.doitserver.in.ua/api';

  Tasks(
    this._bearer,
    this._items,
    this._meta, [
    this._sortOptions = const {
      'sortBy': 'dueBy',
      'direction': 'asc',
    },
  ]) {
    _setSortOptionsFormSharedPreferences();
  }

  List<Task> get items => [..._items];

  Map<String, dynamic> get meta => {..._meta};

  Map<String, String> get sortOptions => {..._sortOptions};

  set sortOptions(Map<String, dynamic> options) => _sortOptions = options;

  Future<void> fetchTasks({int page, String sort, bool refresh = true}) async {
    try {
      var response = await http.get(
        _url +
            '/tasks?page=${page == null ? 1 : page}&sort=${sort == null ? _sortOptions['sortBy'] + ' ' + _sortOptions['direction'] : sort}',
        headers: {'Authorization': 'Bearer $_bearer'},
      );
      if (response.statusCode != 200) {
        throw 'Something went wrong!';
      }
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['tasks'] == null) {
        return;
      }
      final List<Task> loadedTasks = [];
      responseData['tasks'].forEach((task) {
        loadedTasks.add(Task(
          id: task['id'],
          title: task['title'],
          dueBy: DateTime.fromMillisecondsSinceEpoch(task['dueBy'] * 1000),
          priority: task['priority'],
        ));
      });
      _items = refresh ? loadedTasks : _items + loadedTasks;
      _meta = responseData['meta'];
      notifyListeners();
    } on SocketException catch (_) {
      throw 'No internet connection!';
    } catch (err) {
      throw err;
    }
  }

  Future<void> fetchNewPage() async {
    // Check if we have more tasks on another pages
    if (_meta['current'] < _meta['count'] / _meta['limit']) {
      return fetchTasks(page: _meta['current'] + 1, refresh: false);
    }
  }

  Future<int> addTask(Task task) async {
    try {
      final response = await http.post(
        _url + '/tasks',
        body: {
          'title': task.title,
          'dueBy':
              (task.dueBy.millisecondsSinceEpoch / 1000).round().toString(),
          'priority': task.priority,
        },
        headers: {'Authorization': 'Bearer $_bearer'},
      );
      if (response.statusCode == 201) {
        // Return new sorted tasks from server instead of add new unsorted
        await fetchTasks();
        notifyListeners();
        return json.decode(response.body)['task']['id'];
      } else {
        throw response.body;
      }
    } on SocketException catch (_) {
      throw 'No internet connection!';
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateTask(int taskId, Task task) async {
    try {
      final response = await http.put(
        _url + '/tasks/$taskId',
        body: {
          'title': task.title,
          'dueBy':
              (task.dueBy.millisecondsSinceEpoch / 1000).round().toString(),
          'priority': task.priority,
        },
        headers: {'Authorization': 'Bearer $_bearer'},
      );
      if (response.statusCode != 201 && response.statusCode != 202) {
        throw 'Something went wrong!';
      } else {
        final taskIndex = _items.indexWhere((task) => task.id == taskId);
        _items[taskIndex] = task;
        notifyListeners();
      }
    } on SocketException catch (_) {
      throw 'No internet connection!';
    } catch (err) {
      throw err;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final int taskIndex = _items.indexWhere((task) => task.id == taskId);
      final Task task = _items[taskIndex];
      _items.removeAt(taskIndex);
      var response = await http.delete(
        _url + '/tasks/$taskId',
        headers: {'Authorization': 'Bearer $_bearer'},
      );
      if (response.statusCode != 202) {
        _items.insert(taskIndex, task);
        throw json.decode(response.body)['message'];
      } else {
        _meta['count'] -= 1;
      }
      notifyListeners();
    } on SocketException catch (_) {
      throw 'No internet connection!';
    } catch (err) {
      throw err;
    }
  }

  Task getTaskById(int taskId) {
    return _items.firstWhere((task) => task.id == taskId);
  }

  Future<void> _setSortOptionsFormSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('sortOptions')) {
      prefs.setString('sortOptions', json.encode(_sortOptions));
      return;
    }
    final optionsString = prefs.getString('sortOptions');
    _sortOptions = json.decode(optionsString) as Map<String, dynamic>;
  }
}
