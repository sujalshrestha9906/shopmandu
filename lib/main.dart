import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopmandu/model/user.dart';
import 'package:shopmandu/view/homepage.dart';
import 'package:shopmandu/view/status_page.dart';

final box = Provider<List<User>>((ref) => []);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(milliseconds: 500));
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  final userBox = await Hive.openBox<User>('user');

  runApp(ProviderScope(
      overrides: [box.overrideWithValue(userBox.values.toList())],
      child: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 866),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          home: StatusPage(),
          theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
