import 'package:flutter/foundation.dart';

class Task {
  final int id;
  final String title;
  final DateTime dueBy;
  final String priority;

  Task({
    @required this.id,
    @required this.title,
    @required this.dueBy,
    @required this.priority,
  });
}
