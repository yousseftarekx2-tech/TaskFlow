import 'package:go_router/go_router.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/features/auth/presentation/pages/create_password.dart';
import 'package:task_flow/features/auth/presentation/pages/forgot_password.dart';
import 'package:task_flow/features/auth/presentation/pages/login_screen.dart';
import 'package:task_flow/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:task_flow/features/auth/presentation/pages/verification_code.dart';
// import 'package:task_flow/features/home/presentation/pages/home_screen.dart';
import 'package:task_flow/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:task_flow/features/splash/presentation/pages/splash_screen.dart';
import 'package:task_flow/features/main/presentation/pages/main_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: ((context, state) => const SplashScreen()),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: ((context, state) => const OnboardingScreen()),
      ),
      GoRoute(
        path: Routes.login,
        builder: ((context, state) => const LoginScreen()),
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
    ],
  );
}
