import 'package:flutter/material.dart';
// import 'package:task_flow/core/constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),

    textTheme: const TextTheme(
      headlineLarge: AppTextStyle.headlineLarge,
      headlineMedium: AppTextStyle.headlineMedium,

      titleLarge: AppTextStyle.titleLarge,
      titleMedium: AppTextStyle.titleMedium,

      bodyLarge: AppTextStyle.bodyLarge,
      bodyMedium: AppTextStyle.bodyMedium,

      labelLarge: AppTextStyle.labelLarge,
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),

elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF5A52E0),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 52),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: AppTextStyle.labelLarge,
  ),
),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: AppTextStyle.bodyMedium,
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:task_flow/core/constants/app_colors.dart';
// import 'app_text_styles.dart';

// class AppTheme {
//   AppTheme._();

//   static final ThemeData lightTheme = ThemeData(
//     scaffoldBackgroundColor: AppColors.background,
//     colorScheme: const ColorScheme.light(
//       primary: AppColors.primary,
//     ),
//     textTheme: TextTheme(
//       headlineLarge: AppTextStyle.screenTitle,
//       titleLarge: AppTextStyle.sectionTitle,
//       bodyMedium: AppTextStyle.body
//     )
//   );
// }
