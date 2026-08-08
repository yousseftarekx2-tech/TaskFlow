import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        context.go(Routes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Image.asset(AppImages.logo, width: 200),
              // const SizedBox(height: AppSpacing.md),
              Text(
                "TaskFlow",
                style: AppTextStyle.headlineLarge.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Plan. Focus. Get Things Done.",
                style: AppTextStyle.bodyMedium.copyWith(color: Colors.white70),
              ),
              const Spacer(),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
