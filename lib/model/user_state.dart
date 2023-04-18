import 'package:shopmandu/model/user.dart';

class UserState {
  final bool isError;
  final String errMessage;
  final bool isSuccess;
  final List<User> user;
  final bool isLoad;

  UserState(
      {required this.errMessage,
      required this.isError,
      required this.isLoad,
      required this.isSuccess,
      required this.user});

  UserState copyWith(
      {bool? isError,
      String? errMessage,
      bool? isSuccess,
      bool? isLoad,
      List<User>? user}) {
    return UserState(
        errMessage: errMessage ?? this.errMessage,
        isError: isError ?? this.isError,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess,
        user: user ?? this.user);
  }
}
