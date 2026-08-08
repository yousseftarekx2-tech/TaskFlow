import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/core/assets/app_images.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routing/routes.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';
import 'package:task_flow/core/theme/app_text_style/app_text_styles.dart';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.go(Routes.login);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ],
                ),

                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xl),

                      Container(
                        height: 240,
                        width: 342,
                        child: Image.asset(AppImages.forgotPassword),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),

                      const SizedBox(height: 5),

                      Column(
                        children: [
                          Text(
                            'Enter your email address and we\'ll send you',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: const Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'a password reset link.',
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: const Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 28),

                          Container(
                            alignment: Alignment.centerLeft,
                            width: 342,
                            height: 56,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.3),
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                hint: Text(
                                  "Email Address",
                                  textAlign: TextAlign.start,
                                ),
                                hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }

                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Reset password logic
                                  // هنضيف الـ authentication بعدين
                                }
                              },
                              child: const Text("Send Reset Link"),
                            ),
                          ),

                          const SizedBox(height: 120),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.go(Routes.login);
                              },
                              child: Text(
                                'Back to Sign In',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColors.needthis,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
