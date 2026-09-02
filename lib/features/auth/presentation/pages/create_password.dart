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
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color titleColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallWidth = constraints.maxWidth < 360;
            final bool isShortHeight = constraints.maxHeight < 700;

            final double horizontalPadding = isSmallWidth ? 16 : 20;
            final double imageWidth = isSmallWidth ? 290 : 342;
            final double imageHeight = isSmallWidth
                ? 200
                : isShortHeight
                ? 210
                : 240;

            final double titleFontSize = isSmallWidth ? 24 : 28;
            final double descriptionFontSize = isSmallWidth ? 14 : 15;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    SizedBox(height: isShortHeight ? 18 : AppSpacing.xl),
                    Center(
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: Image.asset(
                          AppImages.createPassword,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: isShortHeight ? 12 : 17),
                    Center(
                      child: Text(
                        l10n.createNewPassword,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                          fontSize: titleFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            l10n.newPasswordMustBeDifferent,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: subtitleColor,
                              fontSize: descriptionFontSize,
                            ),
                          ),
                          Text(
                            l10n.previousOne,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: subtitleColor,
                              fontSize: descriptionFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallWidth ? 20 : 24),
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
                    SizedBox(height: isSmallWidth ? 22 : 28),
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
                    SizedBox(height: isSmallWidth ? 22 : 28),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          context.go(Routes.login);
                        },
                        child: Text(
                          l10n.backToLogin,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.needthis,
                            fontSize: isSmallWidth ? 13 : 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
