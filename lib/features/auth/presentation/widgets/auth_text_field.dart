import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/theme/app_text_style/app_spacing.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    required this.prefixIcon,
  });

  final Widget prefixIcon;
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),

        const SizedBox(height: AppSpacing.sm),

        Container(
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: _isObscured,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Color(0xFF1A1A2E)),
              border: InputBorder.none,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}