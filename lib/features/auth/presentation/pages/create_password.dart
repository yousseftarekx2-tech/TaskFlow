import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final Color titleColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // BACK BUTTON
                // ==================================================
                const SizedBox(height: AppSpacing.md),

                IconButton(
                  onPressed: () {
                    context.go(Routes.verificationCode);
                  },

                  padding: EdgeInsets.zero,

                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),

                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: titleColor,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // IMAGE
                // ==================================================
                Center(
                  child: SizedBox(
                    width: 342,
                    height: 240,
                    child: Image.asset(AppImages.createPassword),
                  ),
                ),

                const SizedBox(height: 17),

                // ==================================================
                // TITLE
                // ==================================================
                Center(
                  child: Text(
                    l10n.createNewPassword,
                    textAlign: TextAlign.center,

                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // DESCRIPTION
                // ==================================================
                Center(
                  child: Column(
                    children: [
                      Text(
                        l10n.newPasswordMustBeDifferent,
                        textAlign: TextAlign.center,

                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        l10n.previousOne,
                        textAlign: TextAlign.center,

                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // NEW PASSWORD
                // ==================================================
                AuthTextField(
                  label: l10n.newPassword,
                  hintText: l10n.enterNewPassword,

                  controller: _passwordController,

                  obscureText: true,

                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: isDark
                        ? AppColors.darkSubtitle
                        : AppColors.lightSubtitle,
                  ),

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
                // CONFIRM PASSWORD
                // ==================================================
                AuthTextField(
                  label: l10n.confirmPassword,
                  hintText: l10n.confirmNewPassword,

                  controller: _confirmPasswordController,

                  obscureText: true,

                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: isDark
                        ? AppColors.darkSubtitle
                        : AppColors.lightSubtitle,
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseConfirmPassword;
                    }

                    if (value != _passwordController.text) {
                      return l10n.passwordsDoNotMatch;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // ==================================================
                // RESET PASSWORD
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.go(Routes.login);
                      }
                    },

                    child: Text(l10n.resetPassword),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // BACK TO LOGIN
                // ==================================================
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.go(Routes.login);
                    },

                    child: Text(
                      l10n.backToLogin,

                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.needthis,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
