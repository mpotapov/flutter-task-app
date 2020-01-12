import 'package:flutter/material.dart';

class AddNotification extends StatefulWidget {
  DateTime _taskDateTime;
  final Function _notificationTimeHandler;
  final _notificationDateTime;

  AddNotification(
    taskDate,
    taskTime,
    this._notificationTimeHandler,
    this._notificationDateTime,
  ) {
    _taskDateTime = DateTime(
      taskDate.year,
      taskDate.month,
      taskDate.day,
      taskTime.hour,
      taskTime.minute,
    );
  }

  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  String _notificationTime = 'None';

  void _chooseNotification(String val) {
    setState(() {
      _notificationTime = val;
    });
    switch (val) {
      case '10 min before':
        widget._notificationTimeHandler(
            widget._taskDateTime.subtract(Duration(minutes: 10)));
        break;
      case '30 min before':
        widget._notificationTimeHandler(
            widget._taskDateTime.subtract(Duration(minutes: 30)));
        break;
      case '1 hour before':
        widget._notificationTimeHandler(
            widget._taskDateTime.subtract(Duration(hours: 1)));
        break;
      case '2 hours before':
        widget._notificationTimeHandler(
            widget._taskDateTime.subtract(Duration(hours: 2)));
        break;
      case 'on the same day (9am)':
        widget._notificationTimeHandler(DateTime(
          widget._taskDateTime.year,
          widget._taskDateTime.month,
          widget._taskDateTime.day,
          9,
          0,
          0,
          0,
        ));
        break;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          child: SimpleDialog(
            title: Text('Set notification'),
            children: <Widget>[
              SimpleDialogOption(
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: const Text('10 min before'),
                ),
                onPressed: () => _chooseNotification('10 min before'),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: const Text('30 min before'),
                ),
                onPressed: () => _chooseNotification('30 min before'),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: const Text('1 hour before'),
                ),
                onPressed: () => _chooseNotification('1 hour before'),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: const Text('2 hours before'),
                ),
                onPressed: () => _chooseNotification('2 hours before'),
              ),
              SimpleDialogOption(
                child: ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: const Text('on the same day (9am)'),
                ),
                onPressed: () => _chooseNotification('on the same day (9am)'),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(_deviceData.size.width * 0.025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Notification'),
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    widget._notificationDateTime == null
                        ? _notificationTime
                        : TimeOfDay.fromDateTime(widget._notificationDateTime)
                            .format(context),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
