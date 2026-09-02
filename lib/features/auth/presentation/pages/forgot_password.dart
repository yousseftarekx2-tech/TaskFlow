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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color titleColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                    SizedBox(height: isShortHeight ? 18 : AppSpacing.lg),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: Image.asset(
                              AppImages.forgotPassword,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: isShortHeight ? 18 : 28),
                          Text(
                            l10n.forgotPassword,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                              fontSize: titleFontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.forgotPasswordDescription1,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: subtitleColor,
                              fontSize: descriptionFontSize,
                            ),
                          ),
                          Text(
                            l10n.forgotPasswordDescription2,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: subtitleColor,
                              fontSize: descriptionFontSize,
                            ),
                          ),
                          SizedBox(height: isSmallWidth ? 20 : 28),
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
                          SizedBox(height: isSmallWidth ? 22 : 28),
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
                          SizedBox(
                            height: isShortHeight
                                ? 40
                                : isSmallWidth
                                ? 60
                                : 100,
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(Routes.login);
                            },
                            child: Text(
                              l10n.backToSignIn,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.needthis,
                                fontSize: isSmallWidth ? 13 : 14,
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
            );
          },
        ),
      ),
    );
  }
}
