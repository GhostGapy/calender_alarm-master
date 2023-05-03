import 'package:calender_alarm/event_editor.dart';
import 'package:calender_alarm/event_info.dart';
import 'package:calender_alarm/event_provider.dart';
import 'package:calender_alarm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventView extends StatelessWidget {
  final Event event;

  const EventView({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewingActions(context, event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          buildDateTime(event),
          const SizedBox(
            height: 32,
          ),
          Text(
            event.title,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            event.description,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
        ],
      ));

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event),
      ],
    );
  }

  Widget buildDate(Event event) {
    return Row(
      children: [
        const Icon(Icons.calendar_today),
        const SizedBox(
          width: 8,
        ),
        Text(Utils.toDate(event.from)),
        const SizedBox(
          width: 8,
        ),
        Text(Utils.toTime(event.from)),
      ],
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final provider =
                  Provider.of<EventProvider>(context, listen: false);
              provider.deleteEvent(event);

              Navigator.of(context).pop();
            }),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),
            ),
          ),
        ),
      ];
}
