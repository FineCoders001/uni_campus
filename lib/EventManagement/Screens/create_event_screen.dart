import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String date = "";
  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Event Name"),
              ),
              TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration:
                    const InputDecoration(hintText: "Event Description"),
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Event Venue"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: const Text("Choose Date"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${selectedTime.hour}:${selectedTime.minute}"),
                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: const Text("Choose Time"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.parse(DateTime.now().toString()),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? selectedt =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedt != null && selectedt != selectedTime) {
      setState(() {
        selectedTime = selectedt;
      });
    }
  }
}
