import 'package:flutter/material.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 32),

            Image.asset(
              image,
              width: double.infinity,
              height: 340,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.headlineMedium.copyWith(
                color: const Color(0xFF1A1A2E),
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyMedium.copyWith(
                color: const Color(0xFF9AA8BD),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}