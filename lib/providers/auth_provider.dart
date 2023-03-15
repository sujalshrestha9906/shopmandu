import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart';
import '../model/user.dart';
import '../model/user_state.dart';
import '../services/auth_services.dart';

final authProvider = StateNotifierProvider<AuthProvider, UserState>((ref) =>
    AuthProvider(UserState(
        errMessage: '',
        isLoad: false,
        isSuccess: false,
        isError: false,
        user: ref.watch(box))));

class AuthProvider extends StateNotifier<UserState> {
  AuthProvider(super.state);

  Future<void> userLogin(
      {required String email, required String password}) async {
    state = state.copyWith(isError: false, isLoad: true, isSuccess: false);
    final response =
        await AuthService.userLogin(email: email, password: password);
    response.fold(
        (l) => state = state.copyWith(
            isLoad: false,
            isError: true,
            isSuccess: false,
            errMessage: l,
            user: []),
        (r) => state = state.copyWith(
            isLoad: true, isError: false, isSuccess: true, user: [r]));
  }

  Future<void> userSignUp(
      {required String email,
      required String password,
      required String full_name}) async {
    state = state.copyWith(isError: false, isLoad: true, isSuccess: false);
    final response = await AuthService.userSignUp(
        email: email, password: password, full_name: full_name);
    response.fold(
        (l) => state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errMessage: l),
        (r) =>
            state = state.copyWith(isLoad: true, isError: false, isSuccess: r));
  }

  void userLogOut() async {
    final box = Hive.box<User>('user');
    box.clear();
    state = state.copyWith(user: []);
  }
}
