import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go(Routes.forgotPassword);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
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

              Text(
                "Verify Your Email",
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 7),

              Column(
                children: [
                  Text(
                    'Enter the 6-digit verification code sent to your',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: const Color(0xFF64748B),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'email.',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: const Color(0xFF64748B),
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
                          onChanged: (value) {
                            _onCodeChanged(value, index);
                          },
                          decoration: InputDecoration(
                            hint: Text(
                              "-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF8C94A1),
                              ),
                            ),
                            counterText: '',
                            filled: true,
                            fillColor: AppColors.textFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
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
                      child: const Text('Verify'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code?',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: const Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Resend Code',
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
                      Image.asset(AppImages.clock),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Resend code in 00:59',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: const Color(0xFF94A3B8),
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
