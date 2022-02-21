class EventsDetail {
  late final String eventName;
  late final String venue;
  late final String description;
  late final String deptLevel;
  late final String eventDate;
  late final String eventStartTime;
  late final String eventDuration;
  final String id; //event id
  final String userId;
  late final participants;

  EventsDetail(
      {required this.eventName,
      required this.venue,
      required this.description,
      required this.deptLevel,
      required this.eventDate,
      required this.eventStartTime,
      required this.eventDuration,
      this.id = "",
      this.userId = "",
      this.participants});

  EventsDetail.fromJson(Map json)
      : this(
          eventName: json['eventName']! as String,
          venue: json['venue'] as String,
          description: json['description'] as String,
          deptLevel: json['deptLevel'] as String,
          eventStartTime: json['eventStartTime'] as String,
          eventDate: json['eventDate'].toString(),
          eventDuration: json['eventDuration'].toString(),
          id: json['id'].toString(),
          userId: json['userId'].toString(),
          participants: json['participants'],
        );

  Map<String, Object> toJson() {
    return {
      'eventName': eventName,
      'venue': venue,
      'description': description,
      'deptLevel': deptLevel,
      'eventDate': eventDate,
      'eventStartTime': eventStartTime,
      'eventDuration': eventDuration,
      'id': id,
      'userId': userId,
      'participants': participants
    };
  }
}
