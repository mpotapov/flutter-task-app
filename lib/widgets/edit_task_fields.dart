import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './choose_button.dart';
import './add_notification.dart';

class EditTaskFields extends StatelessWidget {
  final _task;
  final _saving;
  final Function _setTaskStateHandler;
  final Function _setTaskPriorityHandler;
  final Function _setNotificationDateTimeHandler;

  EditTaskFields(
    this._task,
    this._saving,
    this._setTaskStateHandler,
    this._setTaskPriorityHandler,
    this._setNotificationDateTimeHandler,
  );

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);
    final _padding = _deviceData.size.width * 0.025;

    void _datePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2030),
      ).then((selectedDate) {
        if (selectedDate == null) {
          return;
        }
        _setTaskStateHandler('date', selectedDate);
      });
    }

    void _timePicker() {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((selectedTime) {
        if (selectedTime == null) {
          return;
        }
        _setTaskStateHandler('time', selectedTime);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Text(
            'Priority',
            style: TextStyle(
                color: _saving && _task['priority'] == null
                    ? Colors.red
                    : Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: _padding),
          child: FormField(
            builder: (_) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ChooseButton(
                  'High',
                  'High',
                  _setTaskPriorityHandler,
                  _task['priority'],
                ),
                ChooseButton(
                  'Normal',
                  'Normal',
                  _setTaskPriorityHandler,
                  _task['priority'],
                ),
                ChooseButton(
                  'Low',
                  'Low',
                  _setTaskPriorityHandler,
                  _task['priority'],
                ),
              ],
            ),
          ),
        ),
        Divider(color: Theme.of(context).accentColor),
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Expiration date',
                style: TextStyle(
                    color: _saving && _task['date'] == null
                        ? Colors.red
                        : Colors.black),
              ),
              Text(
                _task['date'] == null
                    ? 'Not chosen'
                    : DateFormat.yMd().format(_task['date']),
              ),
              FlatButton(
                child: const Text('Chose date'),
                onPressed: _datePicker,
              ),
            ],
          ),
        ),
        Divider(color: Theme.of(context).accentColor),
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Expiration time',
                style: TextStyle(
                    color: _saving && _task['time'] == null
                        ? Colors.red
                        : Colors.black),
              ),
              Text(
                _task['time'] == null
                    ? 'Not chosen'
                    : _task['time'].format(context),
              ),
              FlatButton(
                child: const Text('Chose time'),
                onPressed: _timePicker,
              )
            ],
          ),
        ),
        Divider(color: Theme.of(context).accentColor),
        _task['time'] == null || _task['date'] == null
            ? Container()
            : Column(
                children: <Widget>[
                  AddNotification(
                    _task['date'],
                    _task['time'],
                    _setNotificationDateTimeHandler,
                  ),
                  Divider(color: Theme.of(context).accentColor),
                ],
              )
      ],
    );
  }
}
