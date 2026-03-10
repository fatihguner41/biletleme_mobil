
import '../entities/event.dart';

class EventListPageModel {
  final List<Event> events;
  final int pageNumber;   // 0-based
  final int totalPages;
  final int totalElements;
  final int pageSize;

  const EventListPageModel({
    required this.events,
    required this.pageNumber,
    required this.totalPages,
    required this.totalElements,
    required this.pageSize,
  });

  bool get hasMore => pageNumber + 1 < totalPages;
}