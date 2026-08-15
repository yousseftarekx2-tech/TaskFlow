import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final Color color;
  final bool IsDefault;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.IsDefault,
  });
  CategoryModel copyWith({
    String? id,
    String? name,
    Color? color,
    bool? IsDefault,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      IsDefault: IsDefault ?? this.IsDefault,
    );
  }
}
