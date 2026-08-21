import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/features/category/data/category_storage.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryStorage _storage;

  CategoryCubit(this._storage) : super(const CategoryState());

  // ============================================================
  // LOAD
  // ============================================================

  Future<void> loadCategories() async {
    emit(state.copyWith(loading: true));

    final categories = await _storage.getCategories();

    emit(CategoryState(categories: categories, loading: false));
  }

  // ============================================================
  // ADD CATEGORY
  // ============================================================

  Future<void> addCategory({
    required String name,
    required Color color,
    required IconData icon,
  }) async {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();

    final CategoryModel category = CategoryModel(
      id: id,
      name: name.trim(),
      color: color,
      icon: icon,
      isDefault: false,
    );

    final List<CategoryModel> updatedCategories = [
      ...state.categories,
      category,
    ];

    await _storage.saveCategories(updatedCategories);

    emit(state.copyWith(categories: updatedCategories));
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<void> deleteCategory(String id) async {
    final category = state.categories.firstWhere(
      (category) => category.id == id,
    );

    // Default categories cannot be deleted.
    if (category.isDefault) {
      return;
    }

    final List<CategoryModel> updatedCategories = state.categories
        .where((category) => category.id != id)
        .toList();

    await _storage.saveCategories(updatedCategories);

    emit(state.copyWith(categories: updatedCategories));
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<void> updateCategory({
    required String id,
    String? name,
    Color? color,
    IconData? icon,
  }) async {
    final List<CategoryModel> updatedCategories = state.categories.map((
      category,
    ) {
      if (category.id != id) {
        return category;
      }

      // Default categories can also be protected from editing.
      if (category.isDefault) {
        return category;
      }

      return category.copyWith(name: name, color: color, icon: icon);
    }).toList();

    await _storage.saveCategories(updatedCategories);

    emit(state.copyWith(categories: updatedCategories));
  }
}
