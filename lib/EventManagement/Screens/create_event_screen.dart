import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

enum Dept { interdept, intradept }

class _CreateEventScreenState extends State<CreateEventScreen> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
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
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: ListView(
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Event Details",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            hintText: "Title",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Venue",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            hintText: "Description",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.grey),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Text(
                              //   "Department:",
                              //   style: TextStyle(fontSize: 18),
                              // ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Event Time",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 50,
                            child: Text(
                              "${months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 50,
                            child: Text(
                              "${selectedTime.hour}:${selectedTime.minute}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         _selectDate(context);
                      //       },
                      //       child: const Text("Choose Date"),
                      //     ),
                      //     Text(
                      //         "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {},
                      //       child: const Text("Choose Time"),
                      //     ),
                      //     Text("${selectedTime.hour}:${selectedTime.minute}"),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              // TextFormField(
              //   decoration: const InputDecoration(hintText: "Event Duration"),
              // ),

              Card(
                elevation: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 61, 182, 65)),
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
