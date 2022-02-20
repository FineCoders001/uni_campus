import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/EventModels/event_details.dart';

Map monthName = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December'
};

Map weekDayName = {
  1: 'Sunday',
  2: 'Monday',
  3: 'Tueday',
  4: 'Wednesday',
  5: 'Thursday',
  6: 'Friday',
  7: 'Saturday',
};

final eventProvider = ChangeNotifierProvider((ref) {
  return AllEvents();
});

class AllEvents extends ChangeNotifier {
  List event1 = ["kjkkj"];

  requestEvent(EventsDetail event) async {
    try {
      // DocumentReference docRef =
      //     await FirebaseFirestore.instance.collection('RequestEvent').add({
      //   'eventName': event.eventName,
      //   'venue': event.venue,
      //   'description': event.description,
      //   'deptLevel': event.deptLevel,
      //   'eventDate': event.eventDate,
      //   'eventStartTime': event.eventStartTime,
      //   'eventDuration': event.eventDuration
      // });
      // await FirebaseFirestore.instance.collection('RequestEvent').doc(FirebaseAuth.instance.currentUser?.uid).set(
      //     {
      //       'eventName': event.eventName,
      //       'venue': event.venue,
      //       'description': event.description,
      //       'deptLevel': event.deptLevel,
      //       'eventDate': event.eventDate,
      //       'eventStartTime': event.eventStartTime,
      //       'eventDuration': event.eventDuration,
      //       //'id':docRef.id,
      //     }
      // );
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('RequestEvent')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("MyRequestedEvents")
          .add({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration,
        //'id':docRef.id,
      });

      await FirebaseFirestore.instance
          .collection('RequestEvent')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("MyRequestedEvents").doc(docRef.id)
          .update({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration,
        'id':docRef.id,
      });

          await FirebaseFirestore.instance.collection('RequestEventAdmin').doc(docRef.id).set({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration,
            'userId':FirebaseAuth.instance.currentUser?.uid,
            'id':docRef.id,

      });


      notifyListeners();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}

class FinalizeEvent {
  approveEvent(event) async {
    try {
      //
      // await FirebaseFirestore.instance.collection("RequestEvent").doc(event.id).delete();
      //
      //  await FirebaseFirestore.instance.collection('ApprovedEvent').doc(event.id).set({
      //    'eventName': event.eventName,
      //    'venue': event.venue,
      //    'description': event.description,
      //    'deptLevel': event.deptLevel,
      //    'eventDate': event.eventDate,
      //    'eventStartTime': event.eventStartTime,
      //    'eventDuration': event.eventDuration,
      //    'id':event.id
      //  });

      // await FirebaseFirestore.instance
      //     .collection("RequestEvent")
      //     .doc(FirebaseAuth.instance.currentUser?.uid)
      //     .delete();
      await FirebaseFirestore.instance
          .collection("RequestEvent")
          .doc(event.userId).collection("MyRequestedEvents").doc(event.id).delete();
      await FirebaseFirestore.instance.collection("RequestEventAdmin").doc(event.id).delete();




      await FirebaseFirestore.instance
          .collection('ApprovedEvent')
          .doc(event.userId).collection("MyApprovedEvents").doc(event.id)
          .set({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration,
        'id':event.id
      });

      await FirebaseFirestore.instance.collection('AllApprovedEvents').doc(event.id).set({
        'eventName': event.eventName,
        'venue': event.venue,
        'description': event.description,
        'deptLevel': event.deptLevel,
        'eventDate': event.eventDate,
        'eventStartTime': event.eventStartTime,
        'eventDuration': event.eventDuration,
        'userId':FirebaseAuth.instance.currentUser?.uid,
        'id':event.id,
      });



      //
      // await FirebaseFirestore.instance
      //     .collection('ApprovedEvent')
      //     .doc(FirebaseAuth.instance.currentUser?.uid).collection("MyApprovedEvents").doc(event.id)
      //     .set({
      //   'eventName': event.eventName,
      //   'venue': event.venue,
      //   'description': event.description,
      //   'deptLevel': event.deptLevel,
      //   'eventDate': event.eventDate,
      //   'eventStartTime': event.eventStartTime,
      //   'eventDuration': event.eventDuration,
      //    'id':event.id
      // });

    } catch (e) {
      print("error is $e");
    }
  }

  rejectEvent(event) async {
    try {
      await FirebaseFirestore.instance
          .collection("RequestEvent")
          .doc(event.userId).collection("MyRequestedEvents").doc(event.id).delete();
      await FirebaseFirestore.instance
          .collection("RequestEventAdmin")
          .doc(event.id).delete();
    } catch (e) {
      print("error is $e");
    }
  }
}

class ApprovedEvents {}
