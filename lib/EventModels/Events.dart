
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_campus/EventModels/EventsDetail.dart';

class events{

  List _event=[];

  requestEvent(EventsDetail event) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('RequestEvent').add(
        {
          'eventName':event.eventName,
          'venue':event.venue,
          'description':event.description,
          'deptLevel':event.deptLevel,
          'eventDate':event.eventDate,
          'eventStartTime':event.eventStartTime
        }
    );
  }

}