import 'package:flutter/material.dart';

class PriorityButton extends StatelessWidget {
  final _priorityButtonTitle;
  final Function _setPriorityHandler;
  final _priority;

  PriorityButton(
    this._priorityButtonTitle,
    this._setPriorityHandler,
    this._priority,
  );

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);
    final _priorityContainerWidth = _deviceData.size.width / 3 - 20;

    return InkWell(
      child: Container(
        width: _priorityContainerWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          color: _priority == _priorityButtonTitle
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        padding: EdgeInsets.all(_deviceData.size.width * 0.025),
        child: Text(_priorityButtonTitle),
      ),
      onTap: () => _setPriorityHandler('priority', _priorityButtonTitle),
    );
  }
}
