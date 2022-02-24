import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Participants extends StatefulWidget {

  var participantsList;
  Participants(this.participantsList);

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Participants",
          style: const TextStyle(color: Colors.grey, fontSize: 24),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
      ),
      body: ListView.builder(
        itemCount: widget.participantsList.length,
          itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 12.0,
              ),
            ],
          ),
          child: ListTile(
            title: Text(widget.participantsList[index]["enrollmentId"],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(widget.participantsList[index][ "department"]),
            //leading: Icon(Icons.event),
          ),
        );

      }),
    );
  }
}
