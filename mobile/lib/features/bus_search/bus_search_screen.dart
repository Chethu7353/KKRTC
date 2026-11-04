import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/models/bus_model.dart';
import '../../shared/models/trip_model.dart';
import '../../shared/repositories/bus_repository.dart';
import '../../shared/widgets/bus_card.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../live_tracking/live_tracking_screen.dart';

class BusSearchScreen extends StatefulWidget {
  final String? initialFrom;
  final String? initialTo;

  const BusSearchScreen({super.key, this.initialFrom, this.initialTo});

  @override
  State<BusSearchScreen> createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  final UnavailableBusRepository _busRepository = UnavailableBusRepository();
  late TextEditingController _fromController;
  late TextEditingController _toController;

  BusServiceType? _selectedServiceType; // null means 'All'
  List<TripModel> _allTrips = [];
  List<TripModel> _filteredTrips = [];
  bool _isLoading = true;

  final List<String> _recentSearches = const [];

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.initialFrom ?? '');
    _toController = TextEditingController(text: widget.initialTo ?? '');
    _executeSearch();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _executeSearch() async {
    setState(() => _isLoading = true);
    final results = await _busRepository.searchTrips(
      fromStop: _fromController.text.trim(),
      toStop: _toController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _allTrips = results;
        _applyFilter();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    if (_selectedServiceType == null) {
      _filteredTrips = List.from(_allTrips);
    } else {
      _filteredTrips = _allTrips
          .where((t) => t.bus.serviceType == _selectedServiceType)
          .toList();
    }
  }

  void _swapStops() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
    _executeSearch();
  }

  void _selectRecent(String recent) {
    final parts = recent.split(' âž” ');
    if (parts.length == 2) {
      setState(() {
        _fromController.text = parts[0];
        _toController.text = parts[1];
      });
      _executeSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text(
          AppStrings.searchBuses,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.midnightNavy,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Search Box with From/To & Swap
          _buildSearchBox(),

          // 2. Service Type Filter Pills
          _buildFilterChips(),

          // 3. Results Header & List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      color: AppColors.midnightNavy,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _fromController,
                        label: AppStrings.fromStop,
                        hint: 'Origin bus stand',
                        prefixIcon: Icons.trip_origin_rounded,
                        onSubmitted: (_) => _executeSearch(),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _toController,
                        label: AppStrings.toStop,
                        hint: 'Destination bus stand',
                        prefixIcon: Icons.location_on_rounded,
                        onSubmitted: (_) => _executeSearch(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _swapStops,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.softYellow,
                    padding: const EdgeInsets.all(12),
                  ),
                  icon: const Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.midnightNavy,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: AppColors.darkBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent queries row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text(
                  'Recent: ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryText,
                  ),
                ),
                ..._recentSearches.map((recent) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => _selectRecent(recent),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.creamBackground,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Text(
                          recent,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Bus Type Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All Services',
                  isSelected: _selectedServiceType == null,
                  onSelected: () {
                    setState(() {
                      _selectedServiceType = null;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: BusServiceType.kalyanaRatha.label,
                  isSelected:
                      _selectedServiceType == BusServiceType.kalyanaRatha,
                  onSelected: () {
                    setState(() {
                      _selectedServiceType = BusServiceType.kalyanaRatha;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: BusServiceType.karnatakaSarige.label,
                  isSelected:
                      _selectedServiceType == BusServiceType.karnatakaSarige,
                  onSelected: () {
                    setState(() {
                      _selectedServiceType = BusServiceType.karnatakaSarige;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: BusServiceType.express.label,
                  isSelected: _selectedServiceType == BusServiceType.express,
                  onSelected: () {
                    setState(() {
                      _selectedServiceType = BusServiceType.express;
                      _applyFilter();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.deepNavy,
      backgroundColor: AppColors.creamBackground,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected ? AppColors.white : AppColors.primaryText,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.deepNavy : AppColors.borderSubtle,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildResultsList() {
    if (_filteredTrips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_bus_outlined,
                size: 54,
                color: AppColors.secondaryText,
              ),
              const SizedBox(height: 12),
              const Text(
                'Bus results unavailable',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'The KKRTC route and trip search service is not connected. No sample buses or schedules are shown.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredTrips.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final trip = _filteredTrips[index];
        return BusCard(
          trip: trip,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LiveTrackingScreen(trip: trip),
              ),
            );
          },
        );
      },
    );
  }
}
