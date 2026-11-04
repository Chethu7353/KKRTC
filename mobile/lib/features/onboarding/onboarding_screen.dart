import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/custom_button.dart';
import '../authentication/role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: AppStrings.onboarding1Title,
      titleKn: AppStrings.onboarding1TitleKn,
      desc: AppStrings.onboarding1Desc,
      descKn: AppStrings.onboarding1DescKn,
      icon: Icons.radar_rounded,
      accentColor: AppColors.goldenYellow,
    ),
    _OnboardingItem(
      title: AppStrings.onboarding2Title,
      titleKn: AppStrings.onboarding2TitleKn,
      desc: AppStrings.onboarding2Desc,
      descKn: AppStrings.onboarding2DescKn,
      icon: Icons.map_rounded,
      accentColor: AppColors.transportOrange,
    ),
    _OnboardingItem(
      title: AppStrings.onboarding3Title,
      titleKn: AppStrings.onboarding3TitleKn,
      desc: AppStrings.onboarding3Desc,
      descKn: AppStrings.onboarding3DescKn,
      icon: Icons.electric_bolt_rounded,
      accentColor: AppColors.deepNavy,
    ),
  ];

  void _onFinish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < _items.length - 1)
            TextButton(
              onPressed: _onFinish,
              child: const Text(
                AppStrings.skip,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom Visual Composition
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            color: item.accentColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: item.accentColor.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              size: 78,
                              color: item.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title in English and Kannada
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                            letterSpacing: -0.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.titleKn,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.transportOrange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          item.desc,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.secondaryText,
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_items.length, (index) {
                final isSelected = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.deepNavy
                        : AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomButton(
                text: _currentPage == _items.length - 1
                    ? AppStrings.getStarted
                    : AppStrings.continueBtn,
                onPressed: () {
                  if (_currentPage == _items.length - 1) {
                    _onFinish();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String titleKn;
  final String desc;
  final String descKn;
  final IconData icon;
  final Color accentColor;

  const _OnboardingItem({
    required this.title,
    required this.titleKn,
    required this.desc,
    required this.descKn,
    required this.icon,
    required this.accentColor,
  });
}
