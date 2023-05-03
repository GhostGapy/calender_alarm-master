import 'package:calender_alarm/event_editor.dart';
import 'package:calender_alarm/event_info.dart';
import 'package:calender_alarm/event_provider.dart';
import 'package:calender_alarm/event_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    List<Event> todayEvents = [];
    List<Event> tomorrowEvents = [];
    List<Event> nextWeekEvents = [];

    for (var event in events) {
      if (event.from.year == today.year &&
          event.from.month == today.month &&
          event.from.day == today.day) {
        todayEvents.add(event);
      } else if (event.from.year == tomorrow.year &&
          event.from.month == tomorrow.month &&
          event.from.day == tomorrow.day) {
        tomorrowEvents.add(event);
      } else if (event.from.isAfter(today) && event.from.isBefore(nextWeek)) {
        nextWeekEvents.add(event);
      }
    }

    return Scaffold(
      body: ListView(
        children: [
          if (todayEvents.isNotEmpty) ...[
            _buildHeader(context, 'Today', todayEvents),
            ...todayEvents
                .map((event) => _buildEventTile(context, event))
                .toList(),
          ],
          if (tomorrowEvents.isNotEmpty) ...[
            _buildHeader(context, 'Tomorrow', tomorrowEvents),
            ...tomorrowEvents
                .map((event) => _buildEventTile(context, event))
                .toList(),
          ],
          if (nextWeekEvents.isNotEmpty) ...[
            _buildHeader(context, 'This week', nextWeekEvents),
            ...nextWeekEvents
                .map((event) => _buildEventTile(context, event))
                .toList(),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 115, 0),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EventEditingPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, List<Event> events) {
    // sort events by date and time
    events.sort((a, b) => a.from.compareTo(b.from));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    return Card(
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(DateFormat('dd.MM.yyyy  HH:mm').format(event.from)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventView(event: event),
            ),
          );
        },
      ),
    );
  }
}
