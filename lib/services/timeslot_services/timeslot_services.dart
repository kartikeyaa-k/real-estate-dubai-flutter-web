import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:real_estate_portal/core/utils/api_constants.dart';
import 'package:real_estate_portal/models/request_models/timeslot_request_model.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_response_model.dart';
import '../../core/error/failure.dart';

abstract class TimeSlotServices {
  Future<Either<Failure, TimeSlotResponseModel>> getTimeSlots({required TimeSlotRequestParam requestParam});
}

class TimeSlotServicesImpl extends TimeSlotServices {
  final Dio dio;

  TimeSlotServicesImpl({required this.dio});

  @override
  Future<Either<Failure, TimeSlotResponseModel>> getTimeSlots({required TimeSlotRequestParam requestParam}) async {
    try {
      final response = await dio.get(timeSlotUrl, queryParameters: requestParam.toMap());
      var jsonDataObject = jsonDecode(response.data);
      TimeSlotResponseModel filterResult = TimeSlotResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
