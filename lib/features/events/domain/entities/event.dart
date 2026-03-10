
class Event {
  final String id;
  final String name;
  String? imageUrl;
  String? date;
  String? venue;
  String? eventType;
  String? eventVenueId;
  String? eventVenueName;

  Event({
    required this.id,
    required this.name,
    this.imageUrl,
    this.date,
    this.venue,
    this.eventType,
    this.eventVenueId,
    this.eventVenueName
  });

}
