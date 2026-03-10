import '../entities/venue.dart';

class VenueSearchPage {
  final List<Venue> venues;
  final int pageNumber;   // 0-based
  final int totalPages;
  final int totalElements;
  final int pageSize;

  const VenueSearchPage({
    required this.venues,
    required this.pageNumber,
    required this.totalPages,
    required this.totalElements,
    required this.pageSize,
  });

  bool get hasMore => pageNumber + 1 < totalPages;
}