import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/storage/user_storage.dart';
import 'package:task_flow/features/auth/data/model/user_model.dart';

class UserCubit extends Cubit<UserModel?> {
  final UserStorage _userStorage;

  UserCubit(this._userStorage) : super(null);

  Future<void> loadUser() async {
    final bool loggedIn = await _userStorage.isLoggedIn();

    if (!loggedIn) {
      emit(null);
      return;
    }

    final UserModel? user = await _userStorage.getUser();

    emit(user);
  }

  Future<void> setUser(UserModel user) async {
    await _userStorage.saveUser(user);
    await _userStorage.setLoggedIn(true);

    emit(user);
  }

  Future<bool> login({required String email, required String password}) async {
    final UserModel? user = await _userStorage.getUser();

    if (user == null) {
      return false;
    }

    final bool credentialsMatch =
        user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
        user.password == password;

    if (!credentialsMatch) {
      return false;
    }

    await _userStorage.setLoggedIn(true);

    emit(user);

    return true;
  }

  Future<void> updateUser(UserModel user) async {
    await _userStorage.saveUser(user);

    emit(user);
  }

  Future<void> logout() async {
    await _userStorage.logout();

    emit(null);
  }

  Future<void> clearUser() async {
    await _userStorage.clearUser();

    emit(null);
  }

  Future<void> completeOnboarding() async {
    await _userStorage.setOnboardingCompleted();
  }
}
