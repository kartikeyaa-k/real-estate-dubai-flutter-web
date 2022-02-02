import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failure.dart';
import '../../core/utils/api_constants.dart';
import '../../models/request_models/add_service_agency_model.dart';
import '../../models/request_models/service_list_request_model.dart';
import '../../models/response_models/emirate_list_models/emirate_list_response_model.dart';
import '../../models/response_models/organisation_types_models/organisation_types_response_model.dart';
import '../../models/response_models/service_list_models/add_service_agency_response_model.dart';
import '../../models/response_models/service_list_models/service_list_response_model.dart';

abstract class ServiceProviderServices {
  Future<Either<Failure, ServiceListResponseModel>> getServiceList({required ServiceListRequestParams requestParam});
  Future<Either<Failure, OrganisationTypesResponseModel>> getOrganisationTypes();
  Future<Either<Failure, EmiratesListResponseModel>> getEmirateList();
  Future<Either<Failure, AddServiceAgencyResponseModel>> addServiceAgency(
      {required AddServiceAgencyRequestParams requestParams});
}

class ServiceProviderServicesImpl extends ServiceProviderServices {
  final Dio dio;

  ServiceProviderServicesImpl({required this.dio});

  @override
  Future<Either<Failure, ServiceListResponseModel>> getServiceList(
      {required ServiceListRequestParams requestParam}) async {
    try {
      final response = await dio.get(
        getServiceListUrl,
        queryParameters: requestParam.toMap(),
      );

      var jsonDataObject = jsonDecode(response.data);

      // print('#log : repo getServiceList response : $jsonDataObject');
      ServiceListResponseModel filterResult = ServiceListResponseModel.fromJson(jsonDataObject);
      // print('#log : repo getServiceList filtered : ${filterResult.result.toString()}');

      return Right(filterResult);
    } on DioError catch (e) {
      print(e);
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, OrganisationTypesResponseModel>> getOrganisationTypes() async {
    try {
      final response = await dio.get(
        getOrganisationTypesUrl,
      );
      var jsonDataObject = jsonDecode(response.data);
      // print('#log : repo getOrganisationTypes response : $jsonDataObject');
      OrganisationTypesResponseModel filterResult = OrganisationTypesResponseModel.fromJson(jsonDataObject);
      // print('#log : repo getOrganisationTypes filtered : ${filterResult.list}');
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, EmiratesListResponseModel>> getEmirateList() async {
    try {
      final response = await dio.get(
        getEmiratesListUrl,
      );

      var jsonDataObject = jsonDecode(response.data);
      // print('#log : repo getEmirateList filtered : ${jsonDataObject}');
      EmiratesListResponseModel filterResult = EmiratesListResponseModel.fromJson(jsonDataObject);

      // print('#log : repo getEmirateList filtered : ${filterResult.data}');
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      // print('ERROR : ${e.toString()}');
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, AddServiceAgencyResponseModel>> addServiceAgency(
      {required AddServiceAgencyRequestParams requestParams}) async {
    try {
      // print('#log : Request : ${requestParams.toMap()}');
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};
      // print('#log : Repo bookTimeSlot => ${headers.toString()}');
      // print('#log ; before netwoork');

      final response = await dio.post(
        addServiceAgencyUrl,
        options: Options(headers: headers),
        data: requestParams.toMap(),
      );
      // print('#log ; after netwoork');
      var jsonDataObject = jsonDecode(response.data);
      // print('#log : repo addServiceAgency res : ${jsonDataObject}');
      AddServiceAgencyResponseModel filterResult = AddServiceAgencyResponseModel.fromJson(jsonDataObject);

      // print('#log : repo getEmirateList filtered : ${filterResult.data}');
      return Right(filterResult);
    } on DioError catch (e, stk) {
      // print('ERROR : ${e.toString()}');
      // print('ERROR : ${stk.toString()}');
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      // print('ERROR : ${e.toString()}');
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
