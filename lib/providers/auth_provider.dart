import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/crud_state.dart';
import '../services/auth_services.dart';

final authProvider = StateNotifierProvider<AuthProvider, CrudState>((ref) =>
    AuthProvider(CrudState(
        errMessage: '', isLoad: false, isSuccess: false, isError: false)));

class AuthProvider extends StateNotifier<CrudState> {
  AuthProvider(super.state);

  Future<void> userLogin(
      {required String email, required String password}) async {
    state = state.copyWith(isError: false, isLoad: true, isSuccess: false);
    final response =
        await AuthService.userLogin(email: email, password: password);
    response.fold(
        (l) => state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errMessage: l),
        (r) =>
            state = state.copyWith(isLoad: true, isError: false, isSuccess: r));
  }
}
