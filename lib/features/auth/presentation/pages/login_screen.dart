import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // SIGN IN
  // ============================================================

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final bool success = await context.read<UserCubit>().login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      _showMessage(AppLocalizations.of(context)!.incorrectEmailOrPassword);

      return;
    }

    context.go(Routes.home);
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isDark = theme.brightness == Brightness.dark;

    final l10n = AppLocalizations.of(context)!;

    final Color textColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    final Color surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: AppSpacing.xxl),

                // ==================================================
                // HEADER
                // ==================================================
                Center(
                  child: Column(
                    children: [
                      Image.asset(AppImages.login),

                      const SizedBox(height: AppSpacing.md),

                      Text(
                        l10n.welcomeBack,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.4,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      Text(
                        l10n.signInToContinue,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // EMAIL
                // ==================================================
                AuthTextField(
                  label: l10n.email,
                  hintText: l10n.enterYourEmail,

                  prefixIcon: const Icon(Icons.email_outlined),

                  controller: _emailController,

                  keyboardType: TextInputType.emailAddress,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterYourEmail;
                    }

                    if (!value.contains('@')) {
                      return l10n.pleaseEnterValidEmail;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // PASSWORD
                // ==================================================
                AuthTextField(
                  label: l10n.password,
                  hintText: l10n.enterYourPassword,

                  obscureText: true,

                  prefixIcon: const Icon(Icons.lock_outline),

                  controller: _passwordController,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterPassword;
                    }

                    if (value.length < 6) {
                      return l10n.passwordMinLength;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // FORGOT PASSWORD
                // ==================================================
                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      context.go(Routes.forgotPassword);
                    },

                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                    ),

                    child: Text(
                      l10n.forgotPassword,

                      style: const TextStyle(
                        color: AppColors.needthis,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // SIGN IN BUTTON
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.needthis,
                      foregroundColor: Colors.white,

                      disabledBackgroundColor: AppColors.needthis.withValues(
                        alpha: 0.55,
                      ),

                      disabledForegroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.signIn,

                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // OR DIVIDER
                // ==================================================
                Row(
                  children: [
                    Expanded(child: Divider(color: borderColor, thickness: 1)),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),

                      child: Text(
                        l10n.or,

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: subtitleColor,
                        ),
                      ),
                    ),

                    Expanded(child: Divider(color: borderColor, thickness: 1)),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // GOOGLE
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: OutlinedButton.icon(
                    onPressed: () {},

                    style: OutlinedButton.styleFrom(
                      backgroundColor: surfaceColor,

                      side: BorderSide(color: borderColor, width: 1),

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    icon: Image.asset(AppImages.google, width: 24, height: 24),

                    label: Text(
                      l10n.continueWithGoogle,

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ==================================================
                // SIGN UP
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      l10n.dontHaveAnAccount,

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        context.go(Routes.signUp);
                      },

                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                      ),

                      child: Text(
                        l10n.signUp,

                        style: const TextStyle(
                          color: AppColors.needthis,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
