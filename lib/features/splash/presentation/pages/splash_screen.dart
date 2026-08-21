import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/storage/user_storage.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/features/streak/presentation/cubit/streak_cubit.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_flow/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  // ============================================================
  // INITIALIZE APP
  // ============================================================

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final userStorage = UserStorage();
    final userCubit = context.read<UserCubit>();

    final bool onboardingCompleted = await userStorage.isOnboardingCompleted();

    final bool loggedIn = await userStorage.isLoggedIn();

    if (!mounted) return;

    // ============================================================
    // USER IS LOGGED IN
    // ============================================================

    if (loggedIn) {
      await userCubit.loadUser();

      if (!mounted) return;

      final user = userCubit.state;

      if (user == null) {
        context.go(Routes.login);
        return;
      }

      // ----------------------------------------------------------
      // WAIT FOR TASKS TO LOAD
      // ----------------------------------------------------------

      final taskBloc = context.read<TaskBloc>();

      if (taskBloc.state is! TaskLoaded) {
        await taskBloc.stream.firstWhere((state) => state is TaskLoaded);
      }

      if (!mounted) return;

      final taskState = taskBloc.state;

      // ----------------------------------------------------------
      // CHECK IF USER HAS AT LEAST ONE TASK
      // ----------------------------------------------------------

      if (taskState is TaskLoaded && taskState.tasks.isNotEmpty) {
        await context.read<StreakCubit>().recordDailyVisit(user.id);
      }

      if (!mounted) return;

      context.go(Routes.home);

      return;
    }

    // ============================================================
    // ONBOARDING NOT COMPLETED
    // ============================================================

    if (!onboardingCompleted) {
      context.go(Routes.onboarding);
      return;
    }

    // ============================================================
    // ONBOARDING COMPLETED BUT NOT LOGGED IN
    // ============================================================

    context.go(Routes.login);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primary,

      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),

              Image.asset(AppImages.logo, width: 200),

              Text(
                "TaskFlow",
                style: AppTextStyle.headlineLarge.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                localizations.splashTagline,
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
