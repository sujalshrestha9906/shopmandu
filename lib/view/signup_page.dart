import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../providers/auth_provider.dart';
import '../providers/common_provider.dart';
import 'widgets/snack_show.dart';

class SignUpPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showFailure(context, next.errMessage);
      } else if (next.isSuccess) {
        Get.back();
        SnackShow.showSuccess(context, 'success');
      }
    });

    final auth = ref.watch(authProvider);
    final mod = ref.watch(mode);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SafeArea(
            child: Form(
              key: _form,
              autovalidateMode: mod,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'SignUp Form',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  TextFormField(
                    controller: nameController,
                    //  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide username';
                      } else if (val.length > 20) {
                        return 'minimum character reached';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Username",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)) {
                        return 'please provide valid email';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Email",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide password';
                      } else if (val.length > 20) {
                        return 'minimum character reached';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ElevatedButton(
                      onPressed: auth.isLoad
                          ? null
                          : () {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if (_form.currentState!.validate()) {
                                ref.read(authProvider.notifier).userSignUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      full_name: nameController.text.trim(),
                                    );
                              } else {
                                ref.read(mode.notifier).change();
                              }
                            },
                      child: auth.isLoad
                          ? Center(child: CircularProgressIndicator())
                          : Text('SignUp')),
                  SizedBox(
                    height: 6.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
                      ),
                      TextButton(
                          onPressed: () {
                            _form.currentState!.reset();
                            Get.back();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
