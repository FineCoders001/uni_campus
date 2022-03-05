import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:uni_campus/EventManagement/Models/all_events.dart';
import 'package:uni_campus/EventManagement/Models/event_details.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

class CreateEventScreen extends StatefulHookConsumerWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

enum Dept { interdept, intradept }

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _form = GlobalKey<FormState>();
  var isLoading = false;
   List<String> items=["1","2","3","4","5","6","7","8"];
  List<String> semester = [];
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
      deptLevel: "",
      eventForSem: "");

  Future<void> _saveForm(context, AllEvents counter) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _form.currentState?.save();
    String sem="";
    for (var element in semester) {
      sem=sem +" "+element;
    }
    if (_d.toString() == "Intradept") {
      _event = EventsDetail(
          eventName: _event.eventName,
          venue: _event.venue,
          description: _event.description,
          deptLevel:
              _d.toString() + " " + ref.read(userCrudProvider).user['deptName'],
          eventDate: selectedDate.toString(),
          eventStartTime: selectedTime.toString(),
          eventDuration: _event.eventDuration + " " + du,
          eventForSem: sem.trim());
    } else {
      _event = EventsDetail(
          eventName: _event.eventName,
          venue: _event.venue,
          description: _event.description,
          deptLevel: _d.toString(),
          eventDate: selectedDate.toString(),
          eventStartTime: selectedTime.toString(),
          eventDuration: _event.eventDuration + " " + du,
          eventForSem: sem.trim());
    }
    print("entered fbkjf fbkjng gnkjnkg");

    try {
      await ref.read(eventProvider).requestEvent(_event);
      // print("entered fbkjf fbkjng gnkjnkg");
    } catch (e) {
      print("error is $e");
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
      rethrow;
    }

    // Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(child: Lottie.asset("assets/loadpaperplane.json"))
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    // color: Colors.white,
                                  )),
                            ],
                          ),
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
                                        child: Text("Event Details",
                                            style: GoogleFonts.ubuntu(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
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
                                                  _event.eventDuration,
                                              eventForSem: _event.eventForSem);
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
                                            eventStartTime:
                                                _event.eventStartTime,
                                            eventDuration: _event.eventDuration,
                                            eventForSem: _event.eventForSem);
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
                                            eventDuration: _event.eventDuration,
                                            eventForSem: _event.eventForSem);
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


                                  GestureDetector(
                                    onTap: () async {
                                      final List<String>? results = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MultiSelect(items: items);
                                        },
                                      );
                                      semester=results!;

                                      //print("result is ${results}");

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
                                          "Select Semester",
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
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
                                                          value.toString(),
                                                      eventForSem:
                                                          _event.eventForSem);
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

  // this variable holds the selected items


// This function is triggered when a checkbox is checked or unchecked


  // this function is called when the Cancel button is pressed


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

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Semester'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}