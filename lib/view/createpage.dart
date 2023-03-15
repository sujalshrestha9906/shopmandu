import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:shopmandu/view/widgets/snack_show.dart';

import '../providers/auth_provider.dart';
import '../providers/common_provider.dart';
import '../providers/crud_provider.dart';

class CreatePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends ConsumerState<CreatePage> {
  final titleController = TextEditingController();

  final detailController = TextEditingController();

  final priceController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(crudProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showFailure(context, next.errMessage);
      } else if (next.isSuccess) {
        Get.back();
        SnackShow.showSuccess(context, 'success');
      }
    });

    final post = ref.watch(crudProvider);

    final image = ref.watch(imageProvider);
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
                    'Create Form',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide title';
                      }
                      return null;
                    },
                    controller: titleController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Title",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide price';
                      }
                      return null;
                    },
                    controller: priceController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.monetization_on),
                        hintText: "Price",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    controller: detailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide detail';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Detail",
                        border: OutlineInputBorder()),
                  ),
                  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Select',
                          content: Text('Choose From'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(imageProvider.notifier)
                                      .imagePick(true);
                                },
                                child: Text('Camera')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(imageProvider.notifier)
                                      .imagePick(false);
                                },
                                child: Text('Gallery')),
                          ]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: image == null
                          ? Center(child: Text('please select an image'))
                          : Image.file(File(image.path)),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ElevatedButton(
                      onPressed: post.isLoad
                          ? null
                          : () {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if (_form.currentState!.validate()) {
                                if (image == null) {
                                  SnackShow.showFailure(
                                      context, 'please select an image');
                                } else {
                                  ref.read(crudProvider.notifier).createProduct(
                                        product_name:
                                            titleController.text.trim(),
                                        product_detail:
                                            detailController.text.trim(),
                                        price: int.parse(
                                            priceController.text.trim()),
                                        image: image,
                                        public_id: '',
                                        imageUrl: '',
                                      );
                                }
                              } else {
                                ref.read(mode.notifier).change();
                              }
                            },
                      child: post.isLoad
                          ? Center(child: CircularProgressIndicator())
                          : Text('submit')),
                  SizedBox(
                    height: 6.h,
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
