import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/api.dart';
import '../exceptions/api_exceptions.dart';
import '../model/product.dart';

final productShow = FutureProvider((ref) => CrudService.getProduct());

class CrudService {
  static Dio dio = Dio();
  static Future<List<Product>> getProduct() async {
    try {
      final response = await dio.get(Api.baseUrl);
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioError catch (err) {
      throw DioException.getDioError(err);
    }
  }

  static Future<Either<String, bool>> productCreate(
      {required String product_name,
      required String product_detail,
      required int price,
      required XFile image,
      required String token}) async {
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
          options: Options(headers: {
            HttpHeaders.authorizationHeader: token,
          }));

      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left(DioException.getDioError(err));
    } on CloudinaryException catch (e) {
      return Left(e.responseString);
    }
  }

  static Future<Either<String, bool>> updateProduct(
      {required String product_name,
      required String product_detail,
      required int price,
      required String productId,
      XFile? image,
      String? public_id,
      required String token}) async {
    try {
      if (image == null) {
        final response = await dio.patch('${Api.updateProduct}/$productId',
            data: {
              'product_name': product_name,
              'product_detail': product_detail,
              'price': price,
              'photo': 'no need'
            },
            options: Options(headers: {
              HttpHeaders.authorizationHeader: token,
            }));
      } else {
        final cloudinary =
            CloudinaryPublic('dau6uv53k', 'musc7x0t', cache: false);
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path,
              resourceType: CloudinaryResourceType.Image),
        );

        final response = await dio.patch('${Api.updateProduct}/$productId',
            data: {
              'product_name': product_name,
              'product_detail': product_detail,
              'price': price,
              'photo': res.secureUrl,
              'public_id': res.publicId,
              'oldImageId': public_id
            },
            options: Options(headers: {
              HttpHeaders.authorizationHeader: token,
            }));
      }

      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left(DioException.getDioError(err));
    } on CloudinaryException catch (e) {
      return Left(e.responseString);
    }
  }

  static Future<Either<String, bool>> removeProduct(
      {required String productId,
      required String publicId,
      required String token}) async {
    try {
      final response = await dio.delete('${Api.addProduct}/$productId',
          data: {'public_id': publicId},
          options: Options(headers: {
            HttpHeaders.authorizationHeader: token,
          }));

      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left(DioException.getDioError(err));
    } on CloudinaryException catch (e) {
      return Left(e.responseString);
    }
  }
}
