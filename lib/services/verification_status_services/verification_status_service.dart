import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failure.dart';
import '../../core/utils/api_constants.dart';
import '../../models/request_models/verification_request_model.dart';
import '../../models/response_models/verification_status_response_models/verification_status_response_model.dart';

abstract class VerificationStatusService {
  Future<Either<Failure, VerificationStatusResponseModel>> getVerificationStatus(
      {required VerificationStatusRequestParams requestParam});

  Future<Either<Failure, bool>> completeVerification({required String propertyId});
}

class VerificationStatusServiceImpl extends VerificationStatusService {
  final Dio dio;

  VerificationStatusServiceImpl({required this.dio});

  @override
  Future<Either<Failure, VerificationStatusResponseModel>> getVerificationStatus(
      {required VerificationStatusRequestParams requestParam}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      final response = await dio.get(
        verificationStatusURL,
        options: Options(headers: headers),
        queryParameters: requestParam.toMap(),
      );
      var jsonDataObject = jsonDecode(response.data);

      VerificationStatusResponseModel filterResult = VerificationStatusResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, bool>> completeVerification({required String propertyId}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      await dio.patch(
        completeVerificationURL,
        // options: Options(headers: headers),
        data: {"property_id": propertyId},
      );

      return Right(true);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
