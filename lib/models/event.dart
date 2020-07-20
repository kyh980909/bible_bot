import 'dart:ui';

class Event {
  Event({this.name, this.from, this.to, this.isAllDay, this.color, this.rrule});

  String name;
  DateTime from;
  DateTime to;
  bool isAllDay;
  Color color;
  String rrule;
}
