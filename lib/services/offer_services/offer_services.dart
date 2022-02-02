import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate_portal/core/utils/api_constants.dart';
import 'package:real_estate_portal/models/request_models/book_status_request_model.dart';
import 'package:real_estate_portal/models/request_models/payment_history_model.dart';
import 'package:real_estate_portal/models/request_models/timeslot_request_model.dart';
import 'package:real_estate_portal/models/response_models/book_status_response_models/book_status_response_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/accept_response_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/decline_response_model.dart';
import 'package:real_estate_portal/models/response_models/payment_history_response_models/payment_history_response_model.dart';
import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_response_model.dart';
import '../../core/error/failure.dart';

abstract class OfferServices {
  Future<Either<Failure, DeclineOfferResponseModel>> declineOffer({required String propertyId});
  Future<Either<Failure, AcceptOfferResponseModel>> acceptOffer({required String propertyId});
  Future<Either<Failure, AcceptOfferResponseModel>> placeOffer({required String planID, required client_offer});
  Future<Either<Failure, PaymentHistoryModelResponseModel>> getPaymentHistory(
      {required PaymentHistoyRequestParams requestParams});
}

class OfferServicesImpl extends OfferServices {
  final Dio dio;

  OfferServicesImpl({required this.dio});

  @override
  Future<Either<Failure, DeclineOfferResponseModel>> declineOffer({required String propertyId}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      final response = await dio.post(
        declineUrl,
        options: Options(headers: headers),
        queryParameters: {'property_id': propertyId},
      );
      var jsonDataObject = jsonDecode(response.data);

      DeclineOfferResponseModel filterResult = DeclineOfferResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, AcceptOfferResponseModel>> acceptOffer({required String propertyId}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      final response = await dio.post(
        acceptOfferUrl,
        options: Options(headers: headers),
        queryParameters: {'property_id': propertyId},
      );
      var jsonDataObject = jsonDecode(response.data);

      AcceptOfferResponseModel filterResult = AcceptOfferResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, AcceptOfferResponseModel>> placeOffer({required String planID, required client_offer}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};
      print('#log : Requst =====> client offer : ${client_offer}  planID : $planID');

      final response = await dio.post(
        placeOfferUrl,
        options: Options(headers: headers),
        queryParameters: {'plan_id': planID, 'client_offer_price': client_offer},
      );

      print('#log L plae offer -===========> ${response.data}');
      var jsonDataObject = jsonDecode(response.data);

      AcceptOfferResponseModel filterResult = AcceptOfferResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }

  @override
  Future<Either<Failure, PaymentHistoryModelResponseModel>> getPaymentHistory(
      {required PaymentHistoyRequestParams requestParams}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};

      final response = await dio.get(
        getPaymentHistoryUrl,
        options: Options(headers: headers),
        queryParameters: requestParams.toMap(),
      );

      var jsonDataObject = jsonDecode(response.data);

      PaymentHistoryModelResponseModel filterResult = PaymentHistoryModelResponseModel.fromJson(jsonDataObject);
      print('res ==========> ${filterResult.paymentHistoryModel.length}');
      return Right(filterResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: timeSlotUrl));
    } catch (e) {
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: timeSlotUrl));
    }
  }
}
