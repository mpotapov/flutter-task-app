import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../widgets/choose_button.dart';

import '../providers/tasks.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharedPreferences _prefs;
  Map<String, dynamic> _sortOptions = {};
  final Map<String, String> _sortOptionsKeyValue = {
    'dueBy': 'Date',
    'title': 'Name',
    'priority': 'Priority',
    'asc': 'Ascending',
    'desc': 'Descending',
  };
  String _defaultSortOptions = '';

  @override
  void initState() {
    fetchSettingsData();
    super.initState();
  }

  Future<void> fetchSettingsData() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey('sortOptions')) {
      return;
    }
    final optionsString = _prefs.getString('sortOptions');
    setState(() {
      _sortOptions = json.decode(optionsString) as Map<String, dynamic>;
    });
    _defaultSortOptions =
        '${_sortOptionsKeyValue[_sortOptions['sortBy']]} ${_sortOptionsKeyValue[_sortOptions['direction']]}';
  }

  void _setSortByState(String val) {
    setState(() {
      _sortOptions['sortBy'] = val;
    });
  }

  void _setPriorityState(String val) {
    setState(() {
      _sortOptions['direction'] = val;
    });
  }

  void _saveSettings() async {
    var areChangesSaved =
        await _prefs.setString('sortOptions', json.encode(_sortOptions));
    if (areChangesSaved) {
      setState(() {
        _defaultSortOptions =
            '${_sortOptionsKeyValue[_sortOptions['sortBy']]} ${_sortOptionsKeyValue[_sortOptions['direction']]}';
        Provider.of<Tasks>(context, listen: false).sortOptions = _sortOptions;
      });
    }
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          areChangesSaved ? 'Saved' : 'Not saved',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);

    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(_deviceData.size.width * 0.04),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Default sorting option:',
                style: Theme.of(context).textTheme.body2,
              ),
              trailing: Text(
                _defaultSortOptions,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('Choose default sorting option:')],
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: _deviceData.size.width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ChooseButton(
                    'Name',
                    'title',
                    _setSortByState,
                    _sortOptions['sortBy'],
                  ),
                  ChooseButton(
                    'Date',
                    'dueBy',
                    _setSortByState,
                    _sortOptions['sortBy'],
                  ),
                  ChooseButton(
                    'Priority',
                    'priority',
                    _setSortByState,
                    _sortOptions['sortBy'],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ChooseButton(
                  'Ascending',
                  'asc',
                  _setPriorityState,
                  _sortOptions['direction'],
                ),
                ChooseButton(
                  'Descending',
                  'desc',
                  _setPriorityState,
                  _sortOptions['direction'],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: _deviceData.size.width * 0.07),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: _saveSettings,
                    child: Text(
                      'Save changes',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
