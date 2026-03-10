import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../bloc/search_venue/search_venue_bloc.dart';
import '../bloc/search_venue/search_venue_event.dart';
import '../bloc/search_venue/search_venue_state.dart';
import 'venue_card.dart';
import 'venue_detail_page.dart';

class VenuesListPage extends StatefulWidget {
  final bool showSearch;

  const VenuesListPage({super.key, this.showSearch = true});

  @override
  State<VenuesListPage> createState() => _VenuesListPageState();
}

class _VenuesListPageState extends State<VenuesListPage> {
  Timer? _debounce;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    final threshold = pos.maxScrollExtent * 0.8;

    if (pos.pixels >= threshold) {
      context.read<SearchVenueBloc>().add(const VenueSearchLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Venues"), backgroundColor: Colors.transparent , surfaceTintColor: Colors.transparent),
        body: Column(
          children: [
            if (widget.showSearch) _buildSearchBar(),
            Expanded(child: _buildVenueList()),
          ],
        ),
      );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (query) {
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 400), () {
            if (!mounted) return;
            context.read<SearchVenueBloc>().add(VenueSearchQueryChanged(query));
          });
        },
        decoration: InputDecoration(
          hintText: "Search venues...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildVenueList() {
    return BlocBuilder<SearchVenueBloc, SearchVenueState>(
      builder: (context, state) {
        if (state.status == SearchVenueStatus.loading && state.venues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == SearchVenueStatus.failure && state.venues.isEmpty) {
          return Center(child: Text(state.errorMessage!));
        }

        final venues = state.venues; // tüm state'lerde ortak alan yapacağız (aşağıda)
        if (venues.isEmpty) {
          return const Center(child: Text("No venues found"));
        }

        final itemCount = venues.length + (state.isLoadingMore ? 1 : 0);

        return ListView.builder(
          controller: _scrollController,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= venues.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final venue = venues[index];
            return VenueCard(
              venue: venue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VenueDetailPage(venue: venue)),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}