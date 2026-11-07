import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/models/trip_model.dart';
import '../../shared/repositories/bus_repository.dart';
import '../../shared/widgets/bus_card.dart';
import '../../shared/widgets/custom_button.dart';
import '../bus_search/bus_search_screen.dart';
import '../../shared/widgets/vac_teams_footer.dart';
import '../live_tracking/live_tracking_screen.dart';

class PassengerHomeTab extends StatefulWidget {
  final Function(int) onNavigateTab;

  const PassengerHomeTab({super.key, required this.onNavigateTab});

  @override
  State<PassengerHomeTab> createState() => _PassengerHomeTabState();
}

class _PassengerHomeTabState extends State<PassengerHomeTab> {
  final UnavailableBusRepository _busRepository = UnavailableBusRepository();
  String _fromLocation = '';
  String _toLocation = '';
  List<TripModel> _nearbyBuses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNearbyBuses();
  }

  void _loadNearbyBuses() async {
    final buses = await _busRepository.getNearbyBuses();
    if (mounted) {
      setState(() {
        _nearbyBuses = buses;
        _isLoading = false;
      });
    }
  }

  void _swapLocations() {
    setState(() {
      final temp = _fromLocation;
      _fromLocation = _toLocation;
      _toLocation = temp;
    });
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.greetingMorning;
    if (hour < 17) return AppStrings.greetingAfternoon;
    return AppStrings.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadNearbyBuses(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header with greeting and profile
                _buildHeader(),

                const SizedBox(height: 16),

                // 2. Main Search Card (Light Yellow & Navy)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildMainSearchCard(),
                ),

                const SizedBox(height: 24),

                // 3. Quick Action Shortcuts
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildQuickActions(),
                ),

                const SizedBox(height: 24),

                // 4. Highlighted Live Tracking Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildLiveTrackingBanner(),
                ),

                const SizedBox(height: 24),

                // 5. Nearby Buses Header & List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.nearbyBuses,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Text(
                            AppStrings.nearbyBusesKn,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.transportOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            widget.onNavigateTab(1), // Go to Search tab
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Nearby Buses Cards
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_nearbyBuses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Live tracking unavailable',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _nearbyBuses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final trip = _nearbyBuses[index];
                      return BusCard(
                        trip: trip,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  LiveTrackingScreen(trip: trip),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const VacTeamsFooter(
                  padding: EdgeInsets.only(top: 24, bottom: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.deepNavy, AppColors.midnightNavy],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.brightCyan,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTimeGreeting(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Passenger',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications unavailable')),
              );
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.brightCyan,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSearchCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmLightYellow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.softYellow, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepNavy.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.searchCardTitle,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.midnightNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Inputs with Swap Button
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  // From Location
                  _buildLocationRow(
                    label: AppStrings.fromStop,
                    value: _fromLocation,
                    icon: Icons.trip_origin_rounded,
                    iconColor: AppColors.successGreen,
                    onTap: () => _openLocationPicker(true),
                  ),
                  const SizedBox(height: 10),
                  // To Location
                  _buildLocationRow(
                    label: AppStrings.toStop,
                    value: _toLocation,
                    icon: Icons.location_on_rounded,
                    iconColor: AppColors.transportOrange,
                    onTap: () => _openLocationPicker(false),
                  ),
                ],
              ),
              // Swap Button
              Positioned(
                right: 12,
                child: Material(
                  color: AppColors.white,
                  elevation: 2,
                  shape: const CircleBorder(
                    side: BorderSide(color: AppColors.borderSubtle),
                  ),
                  child: InkWell(
                    onTap: _swapLocations,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.swap_vert_rounded,
                        size: 20,
                        color: AppColors.deepNavy,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          CustomButton(
            text: AppStrings.searchBuses,
            icon: Icons.search_rounded,
            backgroundColor: AppColors.deepNavy,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BusSearchScreen(
                    initialFrom: _fromLocation,
                    initialTo: _toLocation,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.softYellow),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value.isEmpty ? 'Choose a location' : value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLocationPicker(bool isFrom) async {
    final controller = TextEditingController(
      text: isFrom ? _fromLocation : _toLocation,
    );
    final address = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isFrom ? 'Starting point' : 'Destination'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter an address'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Use address'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (address != null && address.isNotEmpty && mounted) {
      setState(() {
        if (isFrom) {
          _fromLocation = address;
        } else {
          _toLocation = address;
        }
      });
    }
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Track Bus',
        'icon': Icons.location_searching_rounded,
        'tab': 2,
      },
      {'title': 'Find Routes', 'icon': Icons.map_outlined, 'tab': 1},
      {'title': 'Nearby Stops', 'icon': Icons.pin_drop_outlined, 'tab': 1},
      {'title': 'Recent', 'icon': Icons.history_rounded, 'tab': 3},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: () => widget.onNavigateTab(item['tab'] as int),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepNavy.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 24,
                    color: AppColors.deepNavy,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLiveTrackingBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepNavy, AppColors.midnightNavy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepNavy.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      AppStrings.liveBusTracking,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.liveBusTrackingDesc,
                  style: TextStyle(fontSize: 13, color: AppColors.softYellow),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => widget.onNavigateTab(2), // Go to Track tab
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldenYellow,
                    foregroundColor: AppColors.midnightNavy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                  ),
                  child: const Text(
                    AppStrings.trackNow,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.satellite_alt_rounded,
              size: 44,
              color: AppColors.goldenYellow,
            ),
          ),
        ],
      ),
    );
  }
}
