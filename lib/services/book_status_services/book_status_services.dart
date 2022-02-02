import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate_portal/core/utils/api_constants.dart';
import 'package:real_estate_portal/models/request_models/book_status_request_model.dart';
import 'package:real_estate_portal/models/request_models/timeslot_request_model.dart';
import 'package:real_estate_portal/models/response_models/book_status_response_models/book_status_response_model.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_response_model.dart';
import '../../core/error/failure.dart';

abstract class BookStatusServices {
  Future<Either<Failure, BookStatusResponseModel>> getBookStatus({required BookStatusRequestParams requestParam});
}

class BookStatusServicesImpl extends BookStatusServices {
  final Dio dio;

  BookStatusServicesImpl({required this.dio});

  @override
  Future<Either<Failure, BookStatusResponseModel>> getBookStatus({required BookStatusRequestParams requestParam}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      final response = await dio.get(
        bookStatusUrl,
        options: Options(headers: headers),
        queryParameters: requestParam.toMap(),
      );
      var jsonDataObject = jsonDecode(response.data);

      BookStatusResponseModel filterResult = BookStatusResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
