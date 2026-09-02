import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_flow/features/category/data/model/category_model.dart';

class CategoryStorage {
  static const String _categoriesKey = 'categories';

  List<CategoryModel> defaultCategories() {
    return const [
      CategoryModel(
        id: 'design',
        name: 'Design',
        color: Color(0xFF2563EB),
        icon: Icons.design_services_outlined,
        isDefault: true,
      ),
      CategoryModel(
        id: 'meeting',
        name: 'Meeting',
        color: Color(0xFFF97316),
        icon: Icons.groups_outlined,
        isDefault: true,
      ),
      CategoryModel(
        id: 'development',
        name: 'Development',
        color: Color(0xFF16A34A),
        icon: Icons.code_rounded,
        isDefault: true,
      ),
      CategoryModel(
        id: 'work',
        name: 'Work',
        color: Color(0xFF8B5CF6),
        icon: Icons.work_outline_rounded,
        isDefault: true,
      ),
    ];
  }

  Future<List<CategoryModel>> getCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_categoriesKey);

    if (data == null) {
      final List<CategoryModel> defaults = defaultCategories();

      await saveCategories(defaults);

      return defaults;
    }

    try {
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;

      final List<CategoryModel> categories = decoded.map((item) {
        final Map<String, dynamic> json = item as Map<String, dynamic>;

        return CategoryModel(
          id: json['id'] as String,
          name: json['name'] as String,
          color: Color(json['color'] as int),
          icon: IconData(
            // ignore: non_const_argument_for_const_parameter
            json['iconCodePoint'] as int,
            fontFamily: 'MaterialIcons',
          ),
          isDefault: json['isDefault'] as bool,
        );
      }).toList();

      return categories;
    } catch (_) {
      final List<CategoryModel> defaults = defaultCategories();

      await saveCategories(defaults);

      return defaults;
    }
  }

  Future<void> saveCategories(List<CategoryModel> categories) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> data = categories.map((category) {
      return {
        'id': category.id,
        'name': category.name,
        'color': category.color.toARGB32(),
        'iconCodePoint': category.icon.codePoint,
        'isDefault': category.isDefault,
      };
    }).toList();

    await prefs.setString(_categoriesKey, jsonEncode(data));
  }

  Future<void> clearCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_categoriesKey);
  }

  Future<void> clearAllCategories() async {
    await clearCategories();
  }
}
