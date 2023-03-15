import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopmandu/providers/auth_provider.dart';

import 'homepage.dart';
import 'login_page.dart';

class StatusPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    // return ValueListenableBuilder(
    //     valueListenable: Hive.box<Box>('user').listenable(),
    //     builder: (context, box, m) {
    return Scaffold(
      body: auth.user.isEmpty ? LoginPage() : HomePage(),
    );
    // });
  }
}
