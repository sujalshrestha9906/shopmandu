import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../model/crud_state.dart';
import '../services/crud_services.dart';

final crudProvider = StateNotifierProvider<CrudProvider, CrudState>((ref) =>
    CrudProvider(CrudState(
        errMessage: '', isError: false, isLoad: false, isSuccess: false)));

class CrudProvider extends StateNotifier<CrudState> {
  CrudProvider(super.state);

  Future<void> productCreate(
      {required String product_name,
      required String product_detail,
      required int price,
      required XFile image,
      required String token}) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final response = await CrudService.productCreate(
        product_name: product_name,
        product_detail: product_detail,
        price: price,
        image: image,
        token: token);
    response.fold(
        (l) => state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errMessage: l),
        (r) => state = state.copyWith(
            isLoad: false, isError: false, isSuccess: true, errMessage: ''));
  }
}
