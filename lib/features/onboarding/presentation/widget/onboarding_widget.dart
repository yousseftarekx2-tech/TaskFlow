import 'package:flutter/material.dart';

import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';

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
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --------------------------------------------------
            // Illustration
            // --------------------------------------------------
            Image.asset(
              image,
              width: double.infinity,
              height: 340,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: AppSpacing.lg),

            // --------------------------------------------------
            // Title
            // --------------------------------------------------
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onBackground,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // --------------------------------------------------
            // Description
            // --------------------------------------------------
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
