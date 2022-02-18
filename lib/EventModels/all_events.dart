import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventModels/event_details.dart';

 Map monthName = {
  1:'January',
  2:'February',
  3:'March',
  4:'April',
  5:'May',
  6:'June',
  7:'July',
  8:'August',
  9:'September',
  10:'October',
  11:'November',
  12:'December'
};

Map weekDayName = {
  1:'Sunday',
  2:'Monday',
  3:'Tueday',
  4:'Wednesday',
  5:'Thursday',
  6:'Friday',
  7:'Saturday',
};


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
      await FirebaseFirestore.instance.collection('RequestEvent').doc(docRef.id,).update(
          {
            'eventName': event.eventName,
            'venue': event.venue,
            'description': event.description,
            'deptLevel': event.deptLevel,
            'eventDate': event.eventDate,
            'eventStartTime': event.eventStartTime,
            'eventDuration': event.eventDuration,
            'id':docRef.id,
          }
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}

class FinalizeEvent{

  approveEvent(event) async {
    try{

     await FirebaseFirestore.instance.collection("RequestEvent").doc(event.id).delete();


      await FirebaseFirestore.instance.collection('ApprovedEvent').doc(event.id).set({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration,
        'id':event.id
      });
    }catch(e){
      print("error is $e");

    }

  }

  rejectEvent(event){
    try{
      FirebaseFirestore docRef = FirebaseFirestore.instance;
      docRef.collection("RequestEvent").doc(event.id).delete();
    }catch(e){
      print("error is $e");

    }
  }



}
