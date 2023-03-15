import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mode = StateNotifierProvider<ModeProvider, AutovalidateMode>(
    (ref) => ModeProvider(AutovalidateMode.disabled));

class ModeProvider extends StateNotifier<AutovalidateMode> {
  ModeProvider(super.state);

  void change() {
    state = AutovalidateMode.onUserInteraction;
  }
}
