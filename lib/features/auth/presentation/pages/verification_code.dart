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
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    final Color fieldBackground = isDark
        ? AppColors.darkSurface
        : AppColors.textFieldColor;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0);

    final Color iconColor = isDark
        ? AppColors.darkSubtitle
        : const Color(0xFF8C94A1);

    return Scaffold(
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
            final double descriptionFontSize = isSmallWidth ? 14 : 16;

            final double codeFieldWidth = isSmallWidth ? 43 : 48;
            final double codeFieldHeight = isSmallWidth ? 52 : 56;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        context.go(Routes.forgotPassword);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: isShortHeight
                        ? 18
                        : isSmallWidth
                        ? 24
                        : AppSpacing.xl,
                  ),
                  SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: Image.asset(
                      AppImages.verfication,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: isSmallWidth ? 12 : 16),
                  Text(
                    l10n.verifyYourEmail,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    l10n.verificationCodeDescription1,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: subtitleColor,
                      fontSize: descriptionFontSize,
                    ),
                  ),
                  Text(
                    l10n.verificationCodeDescription2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: subtitleColor,
                      fontSize: descriptionFontSize,
                    ),
                  ),
                  SizedBox(height: isSmallWidth ? 20 : AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: codeFieldWidth,
                        height: codeFieldHeight,
                        child: TextFormField(
                          controller: _controller[index],
                          focusNode: _focusNode[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: isSmallWidth ? 18 : 20,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (value) {
                            _onCodeChanged(value, index);
                          },
                          decoration: InputDecoration(
                            hintText: '-',
                            hintStyle: TextStyle(
                              fontSize: isSmallWidth ? 26 : 30,
                              color: iconColor,
                            ),
                            counterText: '',
                            filled: true,
                            fillColor: fieldBackground,
                            contentPadding: EdgeInsets.zero,
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
                  SizedBox(height: isSmallWidth ? 22 : AppSpacing.xl),
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
                      child: Text(
                        l10n.verify,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.didntReceiveTheCode,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: subtitleColor,
                            fontSize: isSmallWidth ? 13 : 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        child: Text(
                          l10n.resendCode,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.needthis,
                            fontSize: isSmallWidth ? 13 : 14,
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
                          fontSize: isSmallWidth ? 12 : 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
