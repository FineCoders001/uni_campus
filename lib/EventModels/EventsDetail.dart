import 'package:flutter/material.dart';

class EventsDetail{
  late final String eventName;
  late final String venue;
  late final String description;
  late final String deptLevel;
  late final String eventDate;
  late final String eventStartTime;
  late final String eventDuration;



  EventsDetail({required this.eventName,required this.venue,required this.description,
    required this.deptLevel,required this.eventDate,required this.eventStartTime,required this.eventDuration});

    EventsDetail.fromJson(Map  json)
      : this(
      eventName: json['eventName']! as String,
      venue: json['venue'] as String,
      description: json['description'] as String,
      deptLevel: json['deptLevel'] as String,
      eventStartTime: json['eventStartTime'] as String,
      eventDate: json['eventDate'].toString() as String,
        eventDuration: json['eventDuration'].toString() as String
  );



  Map<String,Object> toJson() {
    return {
      'eventName':this.eventName,
      'venue':this.venue,
      'description':this.description,
      'deptLevel':this.deptLevel,
      'eventDate':this.eventDate,
      'eventStartTime':this.eventStartTime,
      'eventDuration':this.eventDuration,
    };
  }
}