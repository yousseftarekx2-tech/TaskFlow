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
    this.validator,
    this.keyboardType,
  });

  final Widget prefixIcon;
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

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
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color textColor = isDark ? AppColors.darkText : AppColors.lightText;

    final Color subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;

    final Color inputColor = isDark
        ? AppColors.darkInput
        : AppColors.lightInput;

    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    final Color hintColor = isDark ? AppColors.darkHint : AppColors.lightHint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1),
          ),

          child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscured,
            keyboardType: widget.keyboardType,
            validator: widget.validator,

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),

            cursorColor: AppColors.needthis,

            decoration: InputDecoration(
              border: InputBorder.none,

              hintText: widget.hintText,

              hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: hintColor,
              ),

              prefixIcon: IconTheme(
                data: IconThemeData(color: subtitleColor, size: 21),
                child: widget.prefixIcon,
              ),

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
                        color: subtitleColor,
                        size: 21,
                      ),
                    )
                  : null,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              errorStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
