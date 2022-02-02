import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate_portal/core/utils/api_constants.dart';
import 'package:real_estate_portal/models/request_models/get_services_main_model.dart';
import 'package:real_estate_portal/models/request_models/service_enquire_request_model.dart';
import 'package:real_estate_portal/models/response_models/services_main_response_models/get_services_main_response_model.dart';
import 'package:real_estate_portal/models/response_models/services_main_response_models/submit_enquiry_response_model.dart';
import '../../core/error/failure.dart';

abstract class ServicesMainService {
  Future<Either<Failure, GetServicesMainResponseModel>> getServiceList(
      {required GetServicesMainRequestModel requestParam});
  Future<Either<Failure, SubmitEnquiryResponseModel>> submitEnquiry(
      {required ServiceEnquireRequestParams requestParam});
}

class ServicesMainServiceImpl extends ServicesMainService {
  final Dio dio;

  ServicesMainServiceImpl({required this.dio});

  @override
  Future<Either<Failure, GetServicesMainResponseModel>> getServiceList(
      {required GetServicesMainRequestModel requestParam}) async {
    try {
      final response = await dio.get(
        getServiceMainListUrl,
        queryParameters: requestParam.toMap(),
      );

      var jsonDataObject = jsonDecode(response.data);

      // print('#log : repo getServiceList response : $jsonDataObject');
      GetServicesMainResponseModel filterResult = GetServicesMainResponseModel.fromJson(jsonDataObject);
      // print('#log : repo getServiceList filtered : ${filterResult.result.toString()}');

      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, SubmitEnquiryResponseModel>> submitEnquiry(
      {required ServiceEnquireRequestParams requestParam}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      final response = await dio.post(
        submitServiceEnquiryUrl,
        queryParameters: requestParam.toMap(),
        options: Options(headers: headers),
      );

      var jsonDataObject = jsonDecode(response.data);

      print('#log : repo getServiceList response : $jsonDataObject');
      SubmitEnquiryResponseModel filterResult = SubmitEnquiryResponseModel.fromJson(jsonDataObject);
      // print('#log : repo getServiceList filtered : ${filterResult.result.toString()}');

      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
