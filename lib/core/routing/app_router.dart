import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/about/presentation/pages/about_screen.dart';
import 'package:task_flow/features/auth/presentation/pages/create_password.dart';
import 'package:task_flow/features/auth/presentation/pages/forgot_password.dart';
import 'package:task_flow/features/auth/presentation/pages/login_screen.dart';
import 'package:task_flow/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:task_flow/features/auth/presentation/pages/verification_code.dart';
import 'package:task_flow/features/calendar/presentation/pages/calendar_screen.dart';
import 'package:task_flow/features/focus/presentation/cubit/focus_cubit.dart';
import 'package:task_flow/features/focus/presentation/pages/focus_screen.dart';
import 'package:task_flow/features/home/presentation/pages/today_tasks_screen.dart';
import 'package:task_flow/features/home/presentation/pages/upcoming_tasks_screen.dart';
import 'package:task_flow/features/home/presentation/widgets/notifications_screen.dart';
import 'package:task_flow/features/main/presentation/pages/main_screen.dart';
import 'package:task_flow/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:task_flow/features/profile/presentation/pages/profile_screen.dart';
import 'package:task_flow/features/settings/presnetation/pages/habits_screen.dart';
import 'package:task_flow/features/settings/presnetation/pages/notification_settings_screen.dart';
import 'package:task_flow/features/settings/presnetation/pages/privacy_screen.dart';
import 'package:task_flow/features/settings/presnetation/pages/settings_screen.dart';
import 'package:task_flow/features/settings/presnetation/pages/terms_of_service_screen.dart';
import 'package:task_flow/features/splash/presentation/pages/splash_screen.dart';
import 'package:task_flow/features/statistics/presentation/pages/stats_screen.dart';
import 'package:task_flow/features/tasks/presentation/pages/all_tasks_screen.dart';
import 'package:task_flow/features/category/presentation/pages/categories_screen.dart';
import 'package:task_flow/features/tasks/presentation/pages/completed_tasks_screen.dart';
import 'package:task_flow/features/tasks/presentation/pages/create_task_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPassword(),
      ),

      GoRoute(path: Routes.signUp, builder: (context, state) => const SignUp()),

      GoRoute(
        path: Routes.verificationCode,
        builder: (context, state) => const VerificationCode(),
      ),

      GoRoute(
        path: Routes.createPassword,
        builder: (context, state) => const CreatePassword(),
      ),

      GoRoute(
        path: Routes.home,
        builder: (context, state) => const MainScreen(),
      ),

      GoRoute(
        path: Routes.task,
        builder: (context, state) => const CreateTaskScreen(),
      ),

      GoRoute(
        path: Routes.calendar,
        builder: (context, state) => const CalenderScreen(),
      ),
      GoRoute(
        path: Routes.focus,
        builder: (context, state) => BlocProvider(
          create: (context) => FocusCubit(context.read()),
          child: const FocusScreen(),
        ),
      ),
      GoRoute(
        path: Routes.state,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.allTasks,
        builder: (context, state) => const AllTasksScreen(),
      ),
      GoRoute(
        path: Routes.completedTasks,
        builder: (context, state) => const CompletedTasksScreen(),
      ),
      GoRoute(
        path: Routes.category,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: Routes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: Routes.todayTasks,
        builder: (context, state) => const TodayTasksScreen(),
      ),
      GoRoute(
        path: Routes.upcomingTasks,
        builder: (context, state) => const UpcomingTasksScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.notificationSettingsScreen,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: Routes.habits,
        builder: (context, state) => const HabitsScreen(),
      ),

      GoRoute(
        path: Routes.privacy,
        builder: (context, state) => const PrivacyScreen(),
      ),

      GoRoute(
        path: Routes.termsOfService,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
}
