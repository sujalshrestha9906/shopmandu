import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopmandu/constants/api.dart';
import 'package:shopmandu/exceptions/api_exceptions.dart';

import '../model/user.dart';

class CrudService {
  static Dio dio = Dio();
  static Future<Either<String, bool>> ucreateProduct(
      {required String product_name,
      required String product_detail,
      required int price,
      required String imageUrl,
      required String public_id,
      required XFile image}) async {
    try {
      final cloudinary =
          CloudinaryPublic('CLOUD_NAME', 'UPLOAD_PRESET', cache: false);

      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      final response = await dio.post(Api.addProduct, data: {
        'product_name': product_name,
        'product_detail': product_detail,
        'price': price,
        'imageUrl': imageUrl,
        'public_id': public_id
      });

      final user = User.fromJson(response.data);
      final box = Hive.box<User>('user');
      box.add(user);
      return Right(true);
    } on DioError catch (err) {
      return Left(DioException.getDioError(err));
    } on CloudinaryException catch (e) {
      return Left(e.responseString);
    }
  }
}
