import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopmandu/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(child: Text(auth.user[0].email)),
          ListTile(
              leading: Icon(Icons.person), title: Text(auth.user[0].username)),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).userLogOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          )
        ],
      )),
      body: const Placeholder(),
    );
  }
}
