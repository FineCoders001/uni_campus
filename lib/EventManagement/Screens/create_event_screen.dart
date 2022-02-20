import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../EventModels/all_events.dart';
import '../../EventModels/event_details.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

enum Dept { interdept, intradept }

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _form = GlobalKey<FormState>();
  var isLoading = false;
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
  String du = "Hour";
  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Dept _d = Dept.interdept;

  late EventsDetail _event = EventsDetail(
      eventName: "",
      venue: "",
      description: "",
      eventDate: DateTime.now().toString(),
      eventStartTime: "",
      eventDuration: "",
      deptLevel: "");

  Future<void> _saveForm(context, AllEvents counter) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _form.currentState?.save();

    _event = EventsDetail(
      eventName: _event.eventName,
      venue: _event.venue,
      description: _event.description,
      deptLevel: _d.toString(),
      eventDate: selectedDate.toString(),
      eventStartTime: selectedTime.toString(),
      eventDuration: _event.eventDuration + " " + du,
    );

    try {
      await counter.requestEvent(_event);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('Something went wrong'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                //return;
              },
            )
          ],
        ),
      );
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text("Event Details"),
        // ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                    key: _form,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: ListView(children: [
                          Card(
                            elevation: 5,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/Card.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        // print("entered");

                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            // Like HookConsumerWidget, we can use hooks inside the builder
                                            //final state = useState(0);
                                            // We can also use the ref parameter to listen to providers.
                                            final counter =
                                                ref.watch(eventProvider);
                                            return Text("Event Details",
                                                style: GoogleFonts.ubuntu(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold));
                                          },
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextFormField(
                                        decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                          hintText: "Title",
                                        ),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return 'Please provide a value!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _event = EventsDetail(
                                              eventName: value.toString(),
                                              venue: _event.venue,
                                              description: _event.description,
                                              deptLevel: _event.deptLevel,
                                              eventDate: _event.eventDate,
                                              eventStartTime:
                                                  _event.eventStartTime,
                                              eventDuration:
                                                  _event.eventDuration);
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: "Venue",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Please provide a value!';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _event = EventsDetail(
                                          eventName: _event.eventName,
                                          venue: value.toString(),
                                          description: _event.description,
                                          deptLevel: _event.deptLevel,
                                          eventDate: _event.eventDate,
                                          eventStartTime: _event.eventStartTime,
                                          eventDuration: _event.eventDuration,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextFormField(
                                      maxLines: 3,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: EdgeInsets.all(15),
                                        hintText: "Description",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Please enter a description.';
                                        }
                                        if (value != null &&
                                            value.length < 10) {
                                          return 'Should be at least 10 characters long.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _event = EventsDetail(
                                            eventName: _event.eventName,
                                            venue: _event.venue,
                                            description: value.toString(),
                                            deptLevel: _event.deptLevel,
                                            eventDate: _event.eventDate,
                                            eventStartTime:
                                                _event.eventStartTime,
                                            eventDuration:
                                                _event.eventDuration);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2.0, color: Colors.grey),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // const Text(
                                          //   "Department:",
                                          //   style: TextStyle(fontSize: 18),
                                          // ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                                child: ListTile(
                                                  title: const Text(
                                                      "Interdepartment"),
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.60,
                                                child: ListTile(
                                                  title: const Text(
                                                      "Intradepartment"),
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
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/Card.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        "Event Time",
                                        style: TextStyle(
                                            fontSize: 25,
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
                                          "${months[selectedDate.month - 1]}${selectedDate.day}, ${selectedDate.year}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2.0, color: Colors.grey),
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
                                          "${selectedTime.hour == 12 ? selectedTime.hour : selectedTime.hour % 12}:${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period.toString().substring(10).toUpperCase()}",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2.0, color: Colors.grey),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Text(
                                            "Event Duration:",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 2 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  hintText: "Duration",
                                                ),
                                                validator: (value) {
                                                  if (value != null &&
                                                      value.isEmpty) {
                                                    return 'Please enter a value.';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _event = EventsDetail(
                                                      eventName:
                                                          _event.eventName,
                                                      venue: _event.venue,
                                                      description:
                                                          _event.description,
                                                      deptLevel:
                                                          _event.deptLevel,
                                                      eventDate:
                                                          _event.eventDate,
                                                      eventStartTime:
                                                          _event.eventStartTime,
                                                      eventDuration:
                                                          value.toString());
                                                },
                                              ),
                                            ),
                                            DropdownButton<String>(
                                              // ignore: unnecessary_null_comparison
                                              hint: du == null
                                                  ? const Text("Select")
                                                  : Text(du),

                                              items: <String>["Hour", "Day"]
                                                  .map((String v) {
                                                return DropdownMenuItem(
                                                    value: v, child: Text(v));
                                              }).toList(),

                                              onChanged: (String? newdu) {
                                                setState(() {
                                                  du = newdu as String;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  HookConsumer(
                                    builder: (context, ref, child) {
                                      // Like HookConsumerWidget, we can use hooks inside the builder
                                      //final state = useState(0);

                                      // We can also use the ref parameter to listen to providers.
                                      final counter = ref.watch(eventProvider);
                                      return GestureDetector(
                                        onTap: () async {
                                          //context.read(eventProvider)
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await _saveForm(context, counter);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(15),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            // image: const DecorationImage(
                                            //   image: AssetImage("assets/images/Card.png"),
                                            //   fit: BoxFit.cover,
                                            // ),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Colors.blue,
                                                Colors.cyan,
                                              ],
                                            ),

                                            // border: Border.all(width: 5.0, color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              "Request for the event",
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])))));
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.parse(DateTime.now().toString()),
      lastDate: DateTime(2050),
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
