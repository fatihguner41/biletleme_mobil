import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import 'event_card.dart';
import 'event_detail_page.dart';

class EventPage extends StatefulWidget {
  final bool showSearch;

  const EventPage({super.key, this.showSearch = true});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Timer? _debounce;
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  static const List<String> _categories = [
    'Music',
    'Arts & Theatre',
    'Film',
    'Food & Drink',
    'Casino/Gaming',
    'Fairs & Festivals',
    'Hobby/Special Interest Expos',
    'Ice Shows',
    'Lecture/Seminar',
    'Baseball',
    'Basketball',
    'Boxing',
    'Hockey',
    'Football',
    'Soccer',
    'Volleyball',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    final threshold = pos.maxScrollExtent * 0.8;

    if (pos.pixels >= threshold) {
      context.read<EventBloc>().add(const EventLoadMoreRequested());
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<EventBloc>().add(EventQueryChanged(query));
    });
  }

  void _selectCategory(String category) {
    _searchController.text = "";
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );

    _debounce?.cancel();
    context.read<EventBloc>().add(EventClassificationChanged(category));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showSearch)
            _buildCategorySection(),
          if (widget.showSearch)
            _buildSearchBar(),

          Expanded(child: _buildEventList()),
        ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 108,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final style = _categoryStyle(category);

              return _CategoryCard(
                title: category,
                icon: style.icon,
                colors: style.colors,
                onTap: () => _selectCategory(category),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search events...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              context.read<EventBloc>().add(const EventQueryChanged(''));
              setState(() {});
            },
            icon: const Icon(Icons.close),
          )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading && state.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == EventStatus.failure && state.events.isEmpty) {
          return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
        }

        final events = state.events;
        if (events.isEmpty) {
          return const Center(child: Text('No events found'));
        }

        final itemCount = events.length + (state.isLoadingMore ? 1 : 0);

        return ListView.builder(
          controller: _scrollController,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= events.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final event = events[index];
            return EventCard(
              event: event,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailPage(event: event),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  _CategoryStyle _categoryStyle(String category) {
    switch (category) {
      case 'Music':
        return const _CategoryStyle(
          icon: Icons.music_note_rounded,
          colors: [Color(0xFF7F5AF0), Color(0xFF2CB67D)],
        );
      case 'Arts & Theatre':
        return const _CategoryStyle(
          icon: Icons.theater_comedy_rounded,
          colors: [Color(0xFFFF7A59), Color(0xFFFFC75F)],
        );
      case 'Film':
        return const _CategoryStyle(
          icon: Icons.movie_creation_rounded,
          colors: [Color(0xFF3A86FF), Color(0xFF8338EC)],
        );
      case 'Food & Drink':
        return const _CategoryStyle(
          icon: Icons.restaurant_rounded,
          colors: [Color(0xFFFF8FAB), Color(0xFFFFB703)],
        );
      case 'Casino/Gaming':
        return const _CategoryStyle(
          icon: Icons.casino_rounded,
          colors: [Color(0xFFEF476F), Color(0xFF6A4C93)],
        );
      case 'Fairs & Festivals':
        return const _CategoryStyle(
          icon: Icons.celebration_rounded,
          colors: [Color(0xFFFF9F1C), Color(0xFFFFBF69)],
        );
      case 'Hobby/Special Interest Expos':
        return const _CategoryStyle(
          icon: Icons.interests_rounded,
          colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
        );
      case 'Ice Shows':
        return const _CategoryStyle(
          icon: Icons.ac_unit_rounded,
          colors: [Color(0xFF4CC9F0), Color(0xFF4361EE)],
        );
      case 'Lecture/Seminar':
        return const _CategoryStyle(
          icon: Icons.school_rounded,
          colors: [Color(0xFF577590), Color(0xFF4D908E)],
        );
      case 'Baseball':
        return const _CategoryStyle(
          icon: Icons.sports_baseball_rounded,
          colors: [Color(0xFFE76F51), Color(0xFFF4A261)],
        );
      case 'Basketball':
        return const _CategoryStyle(
          icon: Icons.sports_basketball_rounded,
          colors: [Color(0xFFF77F00), Color(0xFFFCBF49)],
        );
      case 'Boxing':
        return const _CategoryStyle(
          icon: Icons.sports_mma_rounded,
          colors: [Color(0xFFD62828), Color(0xFFF77F00)],
        );
      case 'Hockey':
        return const _CategoryStyle(
          icon: Icons.sports_hockey_rounded,
          colors: [Color(0xFF264653), Color(0xFF2A9D8F)],
        );
      case 'Football':
        return const _CategoryStyle(
          icon: Icons.sports_football_rounded,
          colors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
        );
      case 'Soccer':
        return const _CategoryStyle(
          icon: Icons.sports_soccer_rounded,
          colors: [Color(0xFF1B4332), Color(0xFF52B788)],
        );
      case 'Volleyball':
        return const _CategoryStyle(
          icon: Icons.sports_volleyball_rounded,
          colors: [Color(0xFF5E60CE), Color(0xFF64DFDF)],
        );
      default:
        return const _CategoryStyle(
          icon: Icons.category_rounded,
          colors: [Color(0xFF6C757D), Color(0xFFADB5BD)],
        );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}


class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          width: 170,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryStyle {
  final IconData icon;
  final List<Color> colors;

  const _CategoryStyle({
    required this.icon,
    required this.colors,
  });
}
