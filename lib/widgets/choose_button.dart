import 'package:flutter/material.dart';

class ChooseButton extends StatelessWidget {
  // Title of the created button
  final _buttonTitle;
  // Value of the button
  final _buttonValue;
  // Handler to set element in parent to state
  final Function _setChooseHandler;
  // Item, which is already choosen
  final _chooseItem;
  // How many items in row
  final _countButtonsInARow;

  ChooseButton(
    this._buttonTitle,
    this._buttonValue,
    this._setChooseHandler,
    this._chooseItem, [
    this._countButtonsInARow = 3,
  ]);

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);
    final _chooseContainerWidth =
        _deviceData.size.width / _countButtonsInARow - 20;

    return InkWell(
      child: Container(
        width: _chooseContainerWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          color: _chooseItem == _buttonValue
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
        padding: EdgeInsets.all(_deviceData.size.width * 0.025),
        child: Text(_buttonTitle),
      ),
      onTap: () => _setChooseHandler(_buttonValue),
    );
  }
}
