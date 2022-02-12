import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventModels/event_details.dart';

final eventProvider = ChangeNotifierProvider((ref) {
  return AllEvents();
});

class AllEvents extends ChangeNotifier {
  List event1 = ["kjkkj"];

  requestEvent(EventsDetail event) async {
    try {
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('RequestEvent').add({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration
      });
      event1.add(docRef);

      notifyListeners();
    } catch (e) {
      return e;
    }
    notifyListeners();
  }
}
