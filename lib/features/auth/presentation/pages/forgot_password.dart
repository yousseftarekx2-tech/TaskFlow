import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;

    final l10n = AppLocalizations.of(context)!;

    final Color titleColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // BACK BUTTON
                // ==================================================
                IconButton(
                  onPressed: () {
                    context.go(Routes.login);
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

                const SizedBox(height: AppSpacing.lg),

                // ==================================================
                // CONTENT
                // ==================================================
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 240,
                        width: 342,
                        child: Image.asset(AppImages.forgotPassword),
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // TITLE
                      // ==================================================
                      Text(
                        l10n.forgotPassword,
                        textAlign: TextAlign.center,

                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ==================================================
                      // DESCRIPTION
                      // ==================================================
                      Text(
                        l10n.forgotPasswordDescription1,
                        textAlign: TextAlign.center,

                        style: AppTextStyle.bodyMedium.copyWith(
                          color: subtitleColor,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        l10n.forgotPasswordDescription2,
                        textAlign: TextAlign.center,

                        style: AppTextStyle.bodyMedium.copyWith(
                          color: subtitleColor,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // EMAIL
                      // ==================================================
                      Align(
                        alignment: Alignment.centerLeft,

                        child: AuthTextField(
                          label: l10n.emailAddress,
                          hintText: l10n.enterYourEmailAddress,

                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: isDark
                                ? AppColors.darkSubtitle
                                : AppColors.lightSubtitle,
                          ),

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
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // SEND RESET LINK
                      // ==================================================
                      SizedBox(
                        width: double.infinity,
                        height: 56,

                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.go(Routes.verificationCode);
                            }
                          },

                          child: Text(l10n.sendResetLink),
                        ),
                      ),

                      const SizedBox(height: 100),

                      // ==================================================
                      // BACK TO SIGN IN
                      // ==================================================
                      TextButton(
                        onPressed: () {
                          context.go(Routes.login);
                        },

                        child: Text(
                          l10n.backToSignIn,

                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.needthis,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
