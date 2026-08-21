import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final List<TextEditingController> _controller = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNode = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controller) {
      controller.dispose();
    }

    for (final focusNode in _focusNode) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNode[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNode[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final l10n = AppLocalizations.of(context)!;

    final subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    final fieldBackground = isDark
        ? AppColors.darkSurface
        : AppColors.textFieldColor;

    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE2E8F0);

    final iconColor = isDark ? AppColors.darkSubtitle : const Color(0xFF8C94A1);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.go(Routes.forgotPassword);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                height: 240,
                width: 342,
                child: Image.asset(AppImages.verfication),
              ),

              const SizedBox(height: 16),

              Text(l10n.verifyYourEmail, style: theme.textTheme.headlineLarge),

              const SizedBox(height: 7),

              Column(
                children: [
                  Text(
                    l10n.verificationCodeDescription1,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: subtitleColor,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    l10n.verificationCodeDescription2,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: subtitleColor,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 56,
                        child: TextFormField(
                          controller: _controller[index],
                          focusNode: _focusNode[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            _onCodeChanged(value, index);
                          },
                          decoration: InputDecoration(
                            hintText: '-',
                            hintStyle: TextStyle(
                              fontSize: 30,
                              color: iconColor,
                            ),
                            counterText: '',
                            filled: true,
                            fillColor: fieldBackground,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: borderColor,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.needthis,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        final code = _controller
                            .map((controller) => controller.text)
                            .join();

                        if (code.length == 6) {
                          context.go(Routes.createPassword);
                        }
                      },
                      child: Text(l10n.verify),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.didntReceiveTheCode,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                      ),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          l10n.resendCode,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.needthis,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.clock, width: 18, height: 18),

                      const SizedBox(width: AppSpacing.xs),

                      Text(
                        '${l10n.resendCodeIn} 00:59',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
