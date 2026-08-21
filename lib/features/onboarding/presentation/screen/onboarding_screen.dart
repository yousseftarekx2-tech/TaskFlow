import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/features/onboarding/presentation/widget/onboarding_indicator.dart';
import 'package:task_flow/features/onboarding/presentation/widget/onboarding_widget.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<String> _onboardingIndicators = [
    AppImages.onboardingIndicator1,
    AppImages.onboardingIndicator2,
    AppImages.onboardingIndicator3,
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // Onboarding Content
            // --------------------------------------------------
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingWidget(
                    image: 'assets/images/onboarding_1.png',
                    title: l10n.organizeYourTasksOnboarding,
                    description: l10n.organizeYourTasksOnboardingDescription,
                  ),

                  OnboardingWidget(
                    image: 'assets/images/onboarding_2.png',
                    title: l10n.neverMissADeadline,
                    description: l10n.neverMissADeadlineDescription,
                  ),

                  OnboardingWidget(
                    image: 'assets/images/onboarding_3.png',
                    title: l10n.achieveYourGoals,
                    description: l10n.achieveYourGoalsDescription,
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // Indicator
            // --------------------------------------------------
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: OnboardingIndicator(
                key: ValueKey(_currentPage),
                image: _onboardingIndicators[_currentPage],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // --------------------------------------------------
            // Next / Get Started Button
            // --------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _currentPage == 2
                      ? () {
                          context.go(Routes.login);
                        }
                      : _nextPage,
                  child: Text(_currentPage == 2 ? l10n.getStarted : l10n.next),
                ),
              ),
            ),

            // --------------------------------------------------
            // Skip
            // --------------------------------------------------
            SizedBox(
              height: 48,
              child: TextButton(
                onPressed: _currentPage == 2 ? null : _skipOnboarding,
                child: Text(
                  l10n.skip,
                  style: TextStyle(
                    color: _currentPage == 2
                        ? Colors.transparent
                        : const Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
