import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shopmandu/constants/api.dart';
import 'package:shopmandu/exceptions/api_exceptions.dart';

class AuthService {
  static Dio dio = Dio();
  static Future<Either<String, bool>> userLogin(
      {required String email, required String password}) async {
    try {
      final response = await dio
          .post(Api.login, data: {'email': email, 'password': password});
      return Right(true);
    } on DioError catch (err) {
      return Left(DioException.getDioError(err));
    }
  }
}
