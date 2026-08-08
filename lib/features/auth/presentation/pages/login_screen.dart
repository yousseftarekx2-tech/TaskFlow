import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Column(
                  children: [
                    Image.asset(AppImages.login),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "Sign in to continue",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const AuthTextField(
                label: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              const SizedBox(height: AppSpacing.md),
              const AuthTextField(
                label: "Password",
                hintText: 'Enter your password',
                obscureText: true,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    context.go(Routes.forgotPassword);
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: AppColors.needthis, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Sign In"),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      "OR",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Image.asset(AppImages.google, width: 28, height: 28),
                  label: Text(
                    "Continue with Google",
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  // const SizedBox(width: AppSpacing.xs),
                  TextButton(
                    onPressed: () {
                      context.go(Routes.signUp);
                    },
                    child: Text(
                      'Sign Up',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.needthis,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
