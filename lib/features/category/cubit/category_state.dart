import 'package:equatable/equatable.dart';

import 'package:task_flow/features/category/data/model/category_model.dart';

class CategoryState extends Equatable {
  final List<CategoryModel> categories;
  final bool loading;

  const CategoryState({this.categories = const [], this.loading = false});

  CategoryState copyWith({List<CategoryModel>? categories, bool? loading}) {
    return CategoryState(
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [categories, loading];
}
