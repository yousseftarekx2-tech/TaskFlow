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

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    final userStorage = UserStorage();
    final userCubit = context.read<UserCubit>();

    final bool onboardingCompleted = await userStorage.isOnboardingCompleted();

    final bool loggedIn = await userStorage.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      await userCubit.loadUser();

      if (!mounted) return;

      final user = userCubit.state;

      if (user == null) {
        context.go(Routes.login);
        return;
      }

      final taskBloc = context.read<TaskBloc>();

      if (taskBloc.state is! TaskLoaded) {
        await taskBloc.stream.firstWhere((state) => state is TaskLoaded);
      }

      if (!mounted) return;

      final taskState = taskBloc.state;

      if (taskState is TaskLoaded && taskState.tasks.isNotEmpty) {
        await context.read<StreakCubit>().recordDailyVisit(user.id);
      }

      if (!mounted) return;

      context.go(Routes.home);
      return;
    }

    if (!onboardingCompleted) {
      context.go(Routes.onboarding);
      return;
    }

    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final double logoWidth = isSmallWidth ? 150 : 200;
    final double titleFontSize = isSmallWidth ? 32 : 40;
    final double taglineFontSize = isSmallWidth ? 13 : 14;
    final double progressSize = isSmallWidth ? 22 : 24;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallWidth ? 20 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                AppImages.logo,
                width: logoWidth,
                fit: BoxFit.contain,
              ),
              Text(
                'TaskFlow',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.headlineLarge.copyWith(
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: isShortScreen ? AppSpacing.xs : AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: Text(
                  localizations.splashTagline,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: Colors.white70,
                    fontSize: taglineFontSize,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: progressSize,
                height: progressSize,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(height: isShortScreen ? AppSpacing.lg : AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
