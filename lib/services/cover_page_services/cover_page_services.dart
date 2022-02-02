import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/error/failure.dart';
import '../../core/utils/api_constants.dart';
import '../../models/property_details_models/property_location_detail_model.dart';
import '../../models/response_models/cover_page_models/cover_page_response_model.dart';

abstract class CoverPageService {
  Future<Either<Failure, CoverPageResponseModel>> getCoverPage();
  Future<Either<Failure, PropertyLocationDetailModel>> getPropertyLocationDetails(LatLng position);
}

class CoverPageServiceImpl extends CoverPageService {
  final Dio dio;

  CoverPageServiceImpl({required this.dio});

  @override
  Future<Either<Failure, CoverPageResponseModel>> getCoverPage() async {
    try {
      final response = await dio.get(
        getCoverPageUrl,
      );

      var jsonDataObject = jsonDecode(response.data);

      CoverPageResponseModel filterResult = CoverPageResponseModel.fromJson(jsonDataObject);

      return Right(filterResult);
    } on DioError catch (e) {
      print('#log : ERROR : ${e.toString()}');

      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e, stk) {
      print('#log : ERROR : ${e.toString()}');

      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, PropertyLocationDetailModel>> getPropertyLocationDetails(LatLng position) async {
    String url = "closestLocationList";
    try {
      final response = await dio.get(url, queryParameters: {"lat": position.latitude, "lng": position.longitude});
      var jsonDataObject = jsonDecode(response.data);
      PropertyLocationDetailModel locationResult = PropertyLocationDetailModel.fromJson(jsonDataObject);
      return Right(locationResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }
}
