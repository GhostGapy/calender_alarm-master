import 'package:calender_alarm/event.dart';
import 'package:calender_alarm/utils.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  static of(BuildContext context) {}
}
