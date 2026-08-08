import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/features/onboarding/presentation/widget/onboarding_indicator.dart';
import 'package:task_flow/features/onboarding/presentation/widget/onboarding_widget.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: _skipOnboarding, child: const Text('Skip')),
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
                  title: 'Organize Your Tasks',
                  description:
                      'Keep all your daily tasks organized in one beautiful place and stay productive every day.',
                ),
                OnboardingWidget(
                  image: 'assets/images/onboarding_2.png',
                  title: 'Never miss a deadline',
                  description:
                      'Get smart reminders and notifications so you never forget important tasks and deadlines again.',
                ),
                OnboardingWidget(
                  image: 'assets/images/onboarding_3.png',
                  title: 'Achieve Your Goals',
                  description:
                      'Track your progress, build powerful habits, and accomplish more every day with TaskFlow.',
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: OnboardingIndicator(
              key: ValueKey(_currentPage),
              image: _onboardingIndicators[_currentPage],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _currentPage == 2
                    ? () {
                        context.go(Routes.login);
                      }
                    : _nextPage,
                child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
              ),
            ),
          ),

          TextButton(onPressed: _skipOnboarding, child: const Text('Skip')),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
