import 'dart:io';

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
  static Future<Either<String, bool>> createProduct(
      {required String product_name,
      required String product_detail,
      required int price,
      required String token,
      required XFile image}) async {
    try {
      final cloudinary =
          CloudinaryPublic('dau6uv53k', 'musc7x0t', cache: false);

      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      final response = await dio.post(Api.addProduct,
          data: {
            'product_name': product_name,
            'product_detail': product_detail,
            'price': price,
            'imageUrl': res.secureUrl,
            'public_id': res.publicId
          },
          options: Options(headers: {HttpHeaders.authorizationHeader: token}));

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
