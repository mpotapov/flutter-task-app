import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './choose_button.dart';

class EditTaskFields extends StatelessWidget {
  final _task;
  final _saving;
  final Function _setTaskStateHandler;
  final Function _setTaskPriorityHandler;

  EditTaskFields(
    this._task,
    this._saving,
    this._setTaskStateHandler,
    this._setTaskPriorityHandler,
  );

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);

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
          padding: EdgeInsets.all(_deviceData.size.width * 0.025),
          child: Text(
            'Priority',
            style: TextStyle(
                color: _saving && _task['priority'] == null
                    ? Colors.red
                    : Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: _deviceData.size.width * 0.025),
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
        Divider(
          color: Theme.of(context).accentColor,
        ),
        Padding(
          padding: EdgeInsets.all(_deviceData.size.width * 0.025),
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
        Divider(
          color: Theme.of(context).accentColor,
        ),
        Padding(
          padding: EdgeInsets.all(_deviceData.size.width * 0.025),
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
        Divider(
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
