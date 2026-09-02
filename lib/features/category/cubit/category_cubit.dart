import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/features/category/data/category_storage.dart';
import 'package:task_flow/features/category/data/model/category_model.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryStorage _storage;

  CategoryCubit(this._storage) : super(const CategoryState());

  Future<void> loadCategories() async {
    emit(state.copyWith(loading: true));

    try {
      final List<CategoryModel> categories = await _storage.getCategories();

      if (isClosed) {
        return;
      }

      emit(
        CategoryState(
          categories: categories,
          loading: false,
        ),
      );
    } catch (_) {
      if (isClosed) {
        return;
      }

      emit(
        const CategoryState(
          categories: [],
          loading: false,
        ),
      );
    }
  }

  Future<CategoryModel?> addCategory({
    required String name,
    required Color color,
    required IconData icon,
  }) async {
    final String trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return null;
    }

    final bool alreadyExists = state.categories.any(
      (category) =>
          category.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );

    if (alreadyExists) {
      return null;
    }

    final CategoryModel category = CategoryModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: trimmedName,
      color: color,
      icon: icon,
      isDefault: false,
    );

    final List<CategoryModel> updatedCategories = [
      ...state.categories,
      category,
    ];

    await _storage.saveCategories(updatedCategories);

    if (isClosed) {
      return category;
    }

    emit(
      state.copyWith(
        categories: updatedCategories,
        loading: false,
      ),
    );

    return category;
  }

  Future<void> deleteCategory(String id) async {
    final CategoryModel? category = _findCategory(id);

    if (category == null) {
      return;
    }

    if (category.isDefault) {
      return;
    }

    final List<CategoryModel> updatedCategories = state.categories
        .where((category) => category.id != id)
        .toList();

    await _storage.saveCategories(updatedCategories);

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        categories: updatedCategories,
      ),
    );
  }

  CategoryModel? getCategoryByName(String name) {
    for (final CategoryModel category in state.categories) {
      if (category.name == name) {
        return category;
      }
    }

    return null;
  }

  CategoryModel? getCategoryById(String id) {
    return _findCategory(id);
  }

  CategoryModel? _findCategory(String id) {
    for (final CategoryModel category in state.categories) {
      if (category.id == id) {
        return category;
      }
    }

    return null;
  }

  Future<void> updateCategory({
    required String id,
    String? name,
    Color? color,
    IconData? icon,
  }) async {
    if (name != null && name.trim().isNotEmpty) {
      final String newName = name.trim().toLowerCase();

      final bool duplicate = state.categories.any(
        (category) =>
            category.id != id &&
            category.name.trim().toLowerCase() == newName,
      );

      if (duplicate) {
        return;
      }
    }

    final List<CategoryModel> updatedCategories =
        state.categories.map((category) {
      if (category.id != id) {
        return category;
      }

      if (category.isDefault) {
        return category;
      }

      return category.copyWith(
        name: name?.trim(),
        color: color,
        icon: icon,
      );
    }).toList();

    await _storage.saveCategories(updatedCategories);

    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        categories: updatedCategories,
      ),
    );
  }

  Future<void> clearCategories() async {
    await _storage.clearCategories();

    if (isClosed) {
      return;
    }

    emit(
      const CategoryState(
        categories: [],
        loading: false,
      ),
    );
  }

  Future<void> resetToDefaultCategories() async {
    final List<CategoryModel> defaults = _storage.defaultCategories();

    await _storage.saveCategories(defaults);

    if (isClosed) {
      return;
    }

    emit(
      CategoryState(
        categories: defaults,
        loading: false,
      ),
    );
  }
}