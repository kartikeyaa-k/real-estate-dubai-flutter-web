import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:real_estate_portal/models/request_models/community_buildings_request_model.dart';
import 'package:real_estate_portal/models/request_models/community_detail_request_model.dart';
import 'package:real_estate_portal/models/request_models/popular_building_location_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_building_response_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_details_response_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_guidelines_response_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/popular_building_location_response_model.dart';
import '../../core/error/failure.dart';
import '../../core/utils/api_constants.dart';

abstract class CommunityGuidelineService {
  Future<Either<Failure, CommunityGuidelinesResponseModel>> getCommunityGuidelines();
  Future<Either<Failure, CommunityDetailResponseModel>> getCommunityDetails(CommunityDetailRequestParams requestParams);
  Future<Either<Failure, CommunityBuildingResponseModel>> getCommunityBuilding(CommunityBuildingRequestParams requestParams);
  Future<Either<Failure, PopularBuildingLocationResponseModel>> getPopularBuildingLocation(
      PopularBuildingLocationRequestParams requestParams);
}

class CommunityGuidelineServiceImpl extends CommunityGuidelineService {
  final Dio dio;

  CommunityGuidelineServiceImpl({required this.dio});

  @override
  Future<Either<Failure, CommunityGuidelinesResponseModel>> getCommunityGuidelines() async {
    try {
      final response = await dio.get(
        getCommunitiesGuidelinesUrl,
      );

      var jsonDataObject = jsonDecode(response.data);

      CommunityGuidelinesResponseModel filterResult = CommunityGuidelinesResponseModel.fromJson(jsonDataObject);

      return Right(filterResult);
    } on DioError catch (e) {
      print('#log : ERROR : ${e.toString()}');

      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e, stk) {
      print('#log : ERROR : ${e.toString()}');
      print('#log : ERROR : ${stk.toString()}');
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, CommunityDetailResponseModel>> getCommunityDetails(CommunityDetailRequestParams requestParams) async {
    try {
      final response = await dio.get(getCommunityDetailsUrl, queryParameters: requestParams.toMap());

      var jsonDataObject = jsonDecode(response.data);

      CommunityDetailResponseModel filterResult = CommunityDetailResponseModel.fromJson(jsonDataObject);

      return Right(filterResult);
    } on DioError catch (e) {
      print('#log : ERROR : ${e.error.toString()}');
      print('#log : ERROR : ${e.requestOptions.uri}');
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e, stk) {
      print('#log : ERROR : ${e.toString()}');

      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, CommunityBuildingResponseModel>> getCommunityBuilding(
      CommunityBuildingRequestParams requestParams) async {
    try {
      final response = await dio.get(getCommunityBuildingsUrl, queryParameters: requestParams.toMap());

      var jsonDataObject = jsonDecode(response.data);

      CommunityBuildingResponseModel filterResult = CommunityBuildingResponseModel.fromJson(jsonDataObject);

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
  Future<Either<Failure, PopularBuildingLocationResponseModel>> getPopularBuildingLocation(
      PopularBuildingLocationRequestParams requestParams) async {
    try {
      print('#log : Request : ${requestParams.toMap()}');
      final response = await dio.get(getPopularBuildingLocationUrl, queryParameters: requestParams.toMap());

      var jsonDataObject = jsonDecode(response.data);
      print('#log : res : ${jsonDataObject}');
      PopularBuildingLocationResponseModel filterResult = PopularBuildingLocationResponseModel.fromJson(jsonDataObject);

      return Right(filterResult);
    } on DioError catch (e) {
      print('#log : ERROR : ${e.toString()}');
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e, stk) {
      print('#log : ERROR : ${e.toString()}');
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
