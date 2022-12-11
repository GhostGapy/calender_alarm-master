import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_editor.dart';

class CalenderPage extends StatelessWidget {
  const CalenderPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: const MonthViewSettings(showAgenda: true),
        minDate: DateTime.now(),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    meetings.add(Meeting("Conference for students 1", startTime, endTime,
        const Color.fromARGB(255, 0, 206, 34), false));

    meetings.add(Meeting(
        "Conference for students 2",
        DateTime(2022, 09, 14, 9, 0, 0),
        DateTime(2022, 09, 14, 11, 0, 0),
        const Color.fromARGB(255, 0, 89, 206),
        false));

    meetings.add(Meeting(
        "Conference for students 3",
        DateTime(2022, 09, 14, 10, 0, 0),
        DateTime(2022, 09, 14, 13, 0, 0),
        const Color.fromARGB(255, 0, 89, 206),
        false));

    meetings.add(Meeting(
        "Conference for teachers 1",
        DateTime(2022, 09, 14, 10, 0, 0),
        DateTime(2022, 09, 14, 13, 0, 0),
        const Color.fromARGB(255, 117, 206, 0),
        false));

    meetings.add(Meeting(
        "Conference for teachers 2",
        DateTime(2022, 09, 14, 10, 0, 0),
        DateTime(2022, 09, 14, 13, 0, 0),
        const Color.fromARGB(255, 117, 206, 0),
        false));

    meetings.add(Meeting(
        "Conference for teachers 3",
        DateTime(2022, 09, 14, 10, 0, 0),
        DateTime(2022, 09, 14, 13, 0, 0),
        const Color.fromARGB(255, 117, 206, 0),
        false));

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
