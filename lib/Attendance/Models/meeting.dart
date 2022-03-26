import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Meeting {
  String name;
  DateTime from;
  DateTime to;
  Color color;
  Meeting(this.name, this.from, this.to, this.color);
}

class DS extends CalendarDataSource {
  DS(List<Meeting> appointments) {
    this.appointments = appointments;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).name;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).color;
  }

  Meeting getEvent(int index) {
    return appointments![index] as Meeting;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
