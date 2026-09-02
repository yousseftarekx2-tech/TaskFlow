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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallWidth = constraints.maxWidth < 360;
            final bool isShortHeight = constraints.maxHeight < 700;

            final double horizontalPadding = isSmallWidth ? 16 : 20;
            final double topPadding = isShortHeight
                ? 18
                : isSmallWidth
                ? 24
                : AppSpacing.xxl;

            final double imageWidth = isSmallWidth ? 250 : 290;
            final double imageHeight = isSmallWidth ? 150 : 175;

            final double titleFontSize = isSmallWidth ? 24 : 28;
            final double subtitleFontSize = isSmallWidth ? 13 : 14;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topPadding),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: Image.asset(
                              AppImages.login,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: isSmallWidth ? 10 : AppSpacing.md),
                          Text(
                            l10n.welcomeBack,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l10n.signInToContinue,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: isShortHeight
                          ? 20
                          : isSmallWidth
                          ? 24
                          : AppSpacing.xl,
                    ),
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
                          style: TextStyle(
                            color: AppColors.needthis,
                            fontSize: isSmallWidth ? 13 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallWidth ? 12 : AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.needthis,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.needthis
                              .withValues(alpha: 0.55),
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
                    SizedBox(
                      height: isShortHeight
                          ? 20
                          : isSmallWidth
                          ? 24
                          : AppSpacing.xl,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: borderColor, thickness: 1),
                        ),
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
                        Expanded(
                          child: Divider(color: borderColor, thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallWidth ? 20 : AppSpacing.xl),
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
                        icon: Image.asset(
                          AppImages.google,
                          width: 24,
                          height: 24,
                        ),
                        label: Flexible(
                          child: Text(
                            l10n.continueWithGoogle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallWidth ? 13 : 14,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallWidth ? 14 : AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            l10n.dontHaveAnAccount,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallWidth ? 13 : 14,
                              fontWeight: FontWeight.w500,
                              color: subtitleColor,
                            ),
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
                            style: TextStyle(
                              color: AppColors.needthis,
                              fontSize: isSmallWidth ? 13 : 14,
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
            );
          },
        ),
      ),
    );
  }
}
