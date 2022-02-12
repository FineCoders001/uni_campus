import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventModels/EventsDetail.dart';

final eventProvider = ChangeNotifierProvider((ref) {
  return AllEvents();
});

class AllEvents extends ChangeNotifier{

  List event1=["kjkkj"];




  requestEvent(EventsDetail event) async {
    try{

      print("ajnkdnjksjks");
      DocumentReference docRef = await FirebaseFirestore.instance.collection('RequestEvent').add(
          {
            'eventName':event.eventName,
            'venue':event.venue,
            'description':event.description,
            'deptLevel':event.deptLevel,
            'eventDate':event.eventDate,
            'eventStartTime':event.eventStartTime,
            'eventDuration':event.eventDuration

          }
      );
      event1.add(docRef);
      print("length is ${event1.length}");

      notifyListeners();
    }catch(e){

      print("error is ${e}");

      return e;

    }
    notifyListeners();
  }

}