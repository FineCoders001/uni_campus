import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

enum Dept { interdept, intradept }

class _CreateEventScreenState extends State<CreateEventScreen> {
  String date = "";
  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Dept _d = Dept.interdept;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Event Details"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: const Text("Choose Date"),
                  ),
                  Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: const Text("Choose Time"),
                  ),
                  Text("${selectedTime.hour}:${selectedTime.minute}"),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Event Duration"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Department:",
                    style: TextStyle(fontSize: 18),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: ListTile(
                          title: const Text("Interdepartment"),
                          leading: Radio(
                            value: Dept.interdept,
                            groupValue: _d,
                            onChanged: (Dept? value) {
                              setState(() {
                                _d = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: ListTile(
                          title: const Text("Intradepartment"),
                          leading: Radio(
                            value: Dept.intradept,
                            groupValue: _d,
                            onChanged: (Dept? value) {
                              setState(() {
                                _d = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Submit"),
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
