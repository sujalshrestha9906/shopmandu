import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopmandu/services/crud_services.dart';

import '../main.dart';
import '../model/crud_state.dart';

final crudProvider = StateNotifierProvider<CrudProvider, CrudState>((ref) =>
    CrudProvider(CrudState(
        errMessage: '', isLoad: false, isSuccess: false, isError: false)));

class CrudProvider extends StateNotifier<CrudState> {
  CrudProvider(super.state);

  Future<void> createProduct(
      {required String product_name,
      required String product_detail,
      required int price,
      required String token,
      required XFile image}) async {
    state = state.copyWith(isError: false, isLoad: true, isSuccess: false);
    final response = await CrudService.createProduct(
        product_name: product_name,
        product_detail: product_detail,
        price: price,
        token: token,
        image: image);
    response.fold(
        (l) => state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errMessage: l),
        (r) =>
            state = state.copyWith(isLoad: true, isError: false, isSuccess: r));
  }
}
