import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failure.dart';
import '../../core/utils/api_constants.dart';
import '../../models/request_models/book_time_slot_request_model.dart';
import '../../models/response_models/timeslot_response_models/booked_timeslot_response_model.dart';

abstract class BookTimeSlotServices {
  Future<Either<Failure, BookedTimeSlotResponseModel>> bookTimeSlot({required BookTimeSlotRequestParam requestParam});
}

class BookTimeSlotServicesImpl extends BookTimeSlotServices {
  final Dio dio;

  BookTimeSlotServicesImpl({required this.dio});

  @override
  Future<Either<Failure, BookedTimeSlotResponseModel>> bookTimeSlot(
      {required BookTimeSlotRequestParam requestParam}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};
      print('#log : Repo bookTimeSlot => ${headers.toString()}');
      final response = await dio.post(
        bookTimeSlotUrl,
        options: Options(headers: headers),
        queryParameters: requestParam.toMap(),
      );

      var jsonDataObject = jsonDecode(response.data);
      print('#log : bookTimeSlot Service => ${jsonDataObject}');

      BookedTimeSlotResponseModel filterResult = BookedTimeSlotResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
