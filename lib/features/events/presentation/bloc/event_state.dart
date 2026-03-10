import '../../domain/entities/event.dart';

enum EventStatus { initial, loading, success, failure }

class EventState {
  final EventStatus status;
  final List<Event> events;
  final String query;
  final String classification;
  final String venueId;

  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  final String? errorMessage;

  const EventState({
    required this.status,
    required this.events,
    required this.query,
    required this.venueId,
    required this.classification,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    required this.errorMessage,
  });

  factory EventState.initial() => const EventState(
    status: EventStatus.initial,
    events: [],
    query: "",
    classification: "",
    venueId: "",
    page: 0,
    hasMore: true,
    isLoadingMore: false,
    errorMessage: null,
  );

  EventState copyWith({
    EventStatus? status,
    List<Event>? events,
    String? query,
    String? classification,
    String? venueId,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return EventState(
      status: status ?? this.status,
      events: events ?? this.events,
      query: query ?? this.query,
      classification: classification ?? this.classification,
      venueId: venueId ?? this.venueId,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}