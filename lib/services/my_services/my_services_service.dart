import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/error/failure.dart';
import '../../models/response_models/my_service_models/booked_service_model.dart';
import '../../models/response_models/my_service_models/completed_service_model.dart';
import '../../models/response_models/my_service_models/quoted_service_model.dart';
import '../../models/response_models/my_service_models/requested_service_model.dart';

abstract class MyServicesService {
  Future<Either<Failure, RequestedMyServiceModel>> getRequestedServices();

  Future<Either<Failure, QuotedMyServiceModel>> getQuotedServices();

  Future<Either<Failure, BookedMyServiceModel>> getBookedServices();

  Future<Either<Failure, CompletedMyServiceModel>> getCompleteServices();

  Future<Either<Failure, bool>> addServiceTimeSlot({
    required String fromTime,
    required String toTime,
    required String date,
    required int serviceRequestId,
  });

  Future<Either<Failure, bool>> createTenantServiceRequest({required int propertyId, required int serviceId});

  Future<Either<Failure, bool>> isTenantSatisfied({required int serviceRequestId, required int isSatisfied});
}

class MyServicesServiceImpl extends MyServicesService {
  MyServicesServiceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either<Failure, BookedMyServiceModel>> getBookedServices() async {
    String url = 'my-services/booked';
    try {
      final response = await dio.get(url);
      var jsonDataObject = jsonDecode(response.data);
      BookedMyServiceModel mBookedResults = BookedMyServiceModel.fromJson(jsonDataObject);
      return Right(mBookedResults);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, CompletedMyServiceModel>> getCompleteServices() async {
    String url = 'my-services/completed';
    try {
      final response = await dio.get(url);
      var jsonDataObject = jsonDecode(response.data);
      CompletedMyServiceModel mCompletedResults = CompletedMyServiceModel.fromJson(jsonDataObject);
      return Right(mCompletedResults);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, QuotedMyServiceModel>> getQuotedServices() async {
    String url = 'my-services/quoted';
    try {
      final response = await dio.get(url);
      var jsonDataObject = jsonDecode(response.data);
      QuotedMyServiceModel mQuotedResults = QuotedMyServiceModel.fromJson(jsonDataObject);
      return Right(mQuotedResults);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, RequestedMyServiceModel>> getRequestedServices() async {
    String url = 'my-services/requested';
    try {
      final response = await dio.get(url);
      var jsonDataObject = jsonDecode(response.data);
      RequestedMyServiceModel mRequestedResults = RequestedMyServiceModel.fromJson(jsonDataObject);
      return Right(mRequestedResults);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, bool>> addServiceTimeSlot({
    required String fromTime,
    required String toTime,
    required String date,
    required int serviceRequestId,
  }) async {
    String url = "my-services/addTimeSlot";
    try {
      var data = {
        "from_time": fromTime,
        "to_time": toTime,
        "scheduled_date": date,
        "service_request_id": serviceRequestId
      };
      var response = await dio.post(url, data: data);

      if (response.statusCode == 200) return Right(true);

      return Left(Failure(errorUrl: url, errorMessage: "failed with status code ${response.statusCode}"));
    } on DioError catch (e) {
      return Left(Failure(errorUrl: e.requestOptions.path, errorMessage: jsonDecode(e.message)['message']['message']));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, bool>> createTenantServiceRequest({required int propertyId, required int serviceId}) async {
    String url = "my-services/createRequest";
    try {
      await dio.post(url, data: jsonEncode({"property_id": propertyId, "service_id": serviceId}));
      return Right(true);
    } on DioError catch (e) {
      return Left(Failure(errorUrl: e.requestOptions.path, errorMessage: jsonDecode(e.message)['message']['message']));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, bool>> isTenantSatisfied({required int serviceRequestId, required int isSatisfied}) async {
    String url = "my-services/isSatisfied";
    try {
      await dio.patch(url,
          data: {"service_request_id": serviceRequestId.toString(), "is_satisfied": isSatisfied.toString()});
      return Right(true);
    } on DioError catch (e) {
      return Left(Failure(errorUrl: e.requestOptions.path, errorMessage: e.message));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }
}
