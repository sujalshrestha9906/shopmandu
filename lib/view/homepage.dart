import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

import '../providers/auth_provider.dart';
import '../services/crud_services.dart';
import 'createpage.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    final productData = ref.watch(productShow);
    return Scaffold(
        appBar: AppBar(
          title: Text('Sample Shop'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text(auth.user[0].email)),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(auth.user[0].username),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(() => CreatePage());
                },
                leading: Icon(Icons.add),
                title: Text('add product'),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(authProvider.notifier).userLogOut();
                },
                leading: Icon(Icons.exit_to_app),
                title: Text('LogOut'),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: productData.when(
                data: (data) {
                  return GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: GridTile(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data[index].image,
                                  fit: BoxFit.fitHeight,
                                )),
                            footer: Container(
                              color: Colors.black54,
                              height: 45,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data[index].product_name),
                                  Text(data[index].price.toString())
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                error: (err, stack) => Center(child: Text('$err')),
                loading: () => Center(child: CircularProgressIndicator()))));
  }
}
