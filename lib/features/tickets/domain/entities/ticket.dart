class Ticket {
  final String id;
  final String eventId;
  final String eventName;
  final String qrData;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.qrData,
    required this.createdAt,
  });
}