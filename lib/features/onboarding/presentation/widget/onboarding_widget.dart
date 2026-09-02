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
    final screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final double horizontalPadding = isSmallWidth ? 20 : 32;

    final double topSpacing = isShortScreen ? 12 : 20;

    final double imageHeight = isShortScreen
        ? (screenSize.height * 0.34).clamp(220.0, 290.0)
        : (screenSize.height * 0.38).clamp(260.0, 340.0);

    final double titleFontSize = isSmallWidth ? 26 : 30;

    final double titleSpacing = isShortScreen ? AppSpacing.md : AppSpacing.lg;

    final double descriptionFontSize = isSmallWidth ? 14 : 15;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: topSpacing),
            Image.asset(
              image,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
            SizedBox(height: titleSpacing),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: descriptionFontSize,
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
