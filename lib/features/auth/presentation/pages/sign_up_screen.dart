import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/l10n/app_localizations.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/features/auth/data/model/user_model.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/features/auth/presentation/widgets/auth_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    await context.read<UserCubit>().setUser(user);

    if (!mounted) return;

    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    final Color dividerColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    final Color secondaryTextColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                              AppImages.signUp,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.createAccount,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 11),
                          Text(
                            l10n.createYourAccountToStartOrganized,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            l10n.yourDailyTasks,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
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
                      label: l10n.fullName,
                      hintText: l10n.enterYourFullName,
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterYourName;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AuthTextField(
                      label: l10n.email,
                      hintText: l10n.enterYourEmail,
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.email_outlined),
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
                      controller: _passwordController,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      obscureText: true,
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
                    _buildConfirmPasswordField(
                      isDark: isDark,
                      l10n: l10n,
                      compact: isSmallWidth,
                    ),
                    SizedBox(height: isSmallWidth ? 22 : AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.needthis,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.createAccount,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 13 : 14,
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
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            l10n.or,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
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
                          side: BorderSide(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                            width: 1,
                          ),
                          backgroundColor: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
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
                            style: AppTextStyle.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                              fontSize: isSmallWidth ? 13 : 15,
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
                            l10n.alreadyHaveAnAccount,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: secondaryTextColor,
                              fontSize: isSmallWidth ? 13 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(Routes.login);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          child: Text(
                            l10n.signIn,
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

  Widget _buildConfirmPasswordField({
    required bool isDark,
    required AppLocalizations l10n,
    required bool compact,
  }) {
    final Color labelColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color hintColor = isDark ? AppColors.darkHint : AppColors.lightHint;

    final Color iconColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    final Color fieldColor = isDark
        ? AppColors.darkInput
        : AppColors.lightInput;

    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.confirmPassword,
          style: TextStyle(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w700,
            color: labelColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: fieldColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: TextFormField(
            obscureText: _isConfirmPasswordObscured,
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            cursorColor: AppColors.needthis,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: l10n.confirmYourPassword,
              hintStyle: TextStyle(
                color: hintColor,
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: iconColor,
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                  });
                },
                icon: Icon(
                  _isConfirmPasswordObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: iconColor,
                  size: 20,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: compact ? 14 : 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseConfirmYourPassword;
              }

              if (value != _passwordController.text) {
                return l10n.passwordsDoNotMatch;
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
