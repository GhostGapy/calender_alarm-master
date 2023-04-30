import 'package:calender_alarm/event_info.dart';
import 'package:calender_alarm/event_provider.dart';
import 'package:calender_alarm/event_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_editor.dart';

class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 115, 0),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EventEditingPage()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SfCalendar(
        firstDayOfWeek: 1,
        view: CalendarView.month,
        showDatePickerButton: true,
        allowedViews: const [
          CalendarView.day,
          CalendarView.month,
        ],
        dataSource: EventDataSource(events),
        monthViewSettings: const MonthViewSettings(showAgenda: true),
        minDate: DateTime.now(),
        onTap: (details) => calendarTapped(context, details),
        onLongPress: (details) => addEventLongPress(context, details),
      ),
    );
  }

  void addEventTap(BuildContext context, CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      final DateTime date = details.date!;
      final Event newEvent = Event(
        title: '',
        description: '',
        from: date,
        backgroundColor: Colors.lightGreen,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventEditingPage(event: newEvent),
        ),
      );
    }
  }

  //še ne dela
  void addEventLongPress(
      BuildContext context, CalendarLongPressDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      final DateTime date = details.date!;
      final Event newEvent = Event(
        title: '',
        description: '',
        from: date,
        backgroundColor: Colors.lightGreen,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventEditingPage(event: newEvent),
        ),
      );
    }
  }

  void calendarTapped(
      BuildContext context, CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Event event = calendarTapDetails.appointments![0];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventView(event: event),
        ),
      );
    }
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;
}
