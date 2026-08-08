import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image
    );
  }
}
