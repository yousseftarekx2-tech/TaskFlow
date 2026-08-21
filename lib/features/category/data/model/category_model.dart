import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final bool isDefault;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.isDefault,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    Color? color,
    IconData? icon,
    bool? isDefault,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
