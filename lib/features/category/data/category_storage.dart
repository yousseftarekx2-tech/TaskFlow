import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';

class CategoryStorage {
  static const String _categoriesKey = 'categories';

  // ============================================================
  // DEFAULT CATEGORIES
  // ============================================================

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

  // ============================================================
  // GET CATEGORIES
  // ============================================================

  Future<List<CategoryModel>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_categoriesKey);

    if (data == null) {
      return defaultCategories();
    }

    try {
      final List<dynamic> decoded = jsonDecode(data);

      return decoded.map((item) {
        return CategoryModel(
          id: item['id'] as String,
          name: item['name'] as String,
          color: Color(item['color'] as int),
          icon: IconData(
            item['iconCodePoint'] as int,
            fontFamily: 'MaterialIcons',
          ),
          isDefault: item['isDefault'] as bool,
        );
      }).toList();
    } catch (_) {
      return defaultCategories();
    }
  }

  // ============================================================
  // SAVE CATEGORIES
  // ============================================================

  Future<void> saveCategories(List<CategoryModel> categories) async {
    final prefs = await SharedPreferences.getInstance();

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

  // ============================================================
  // CLEAR
  // ============================================================

  Future<void> clearCategories() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_categoriesKey);
  }
}
