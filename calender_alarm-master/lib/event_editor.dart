import 'package:calender_alarm/event_info.dart';
import 'package:calender_alarm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'event_provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  final descriptionController = TextEditingController();
  late Color tileColor = Colors.green;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
    } else {
      final event = widget.event!;
      titleController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      tileColor = event.backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildEdtingActions(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Add Event ',
              style: TextStyle(
                fontFamily: 'OpenSansBold',
                fontSize: 22.0,
              ),
            ),
            Icon(
              Icons.add_alarm,
              color: Colors.white,
              size: 25.0,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              const SizedBox(height: 40),
              buildDateTimePickers(),
              const SizedBox(height: 22),
              TextFormField(
                maxLines: null, // Allows for multiple lines of text input
                keyboardType: TextInputType
                    .multiline, // Allows for new lines in text input
                decoration: const InputDecoration(
                  hintText: 'Enter your text here',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 16),
                minLines: 5,
                onFieldSubmitted: (_) => saveFrom(),
                validator: (title) => title != null && title.isEmpty
                    ? 'Title cannot be empty!'
                    : null,
                controller: descriptionController,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: tileColor,
                decoration: const InputDecoration(
                  labelText: 'Event Color',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: Colors.black,
                    child: Text(
                      'Black',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: Colors.red,
                    child: Text(
                      'Red',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: Colors.green,
                    child: Text(
                      'Green',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: Colors.blue,
                    child: Text(
                      'Blue',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: Colors.purple,
                    child: Text(
                      'Purple',
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    tileColor = value as Color;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEdtingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 66, 66, 66),
            shadowColor: const Color.fromARGB(255, 66, 66, 66),
          ),
          onPressed: saveFrom,
          icon: const Icon(Icons.done),
          label: const Text('Save'),
        )
      ];

  Widget buildTitle() => TextFormField(
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) => saveFrom(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty!' : null,
        controller: titleController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: 'TIME',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;

    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            header,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          child,
          const SizedBox(height: 12),
        ],
      );

  Future saveFrom() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
          title: titleController.text,
          description: descriptionController.text,
          from: fromDate,
          backgroundColor: tileColor);

      final isEditing = widget.event != null;

      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);
      } else {
        provider.addEvent(event);
      }

      Navigator.of(context).pop();
    }
  }
}
