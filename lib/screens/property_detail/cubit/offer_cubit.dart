import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/payment_history_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/accept_response_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/decline_response_model.dart';
import 'package:real_estate_portal/models/response_models/payment_history_response_models/payment_history_response_model.dart';
import 'package:real_estate_portal/services/offer_services/offer_services.dart';

part 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  OfferServices _offerServices;

  OfferCubit({required OfferServices offerServices})
      : _offerServices = offerServices,
        super(OfferInit());

  Future<void> declineOffer(String projectId) async {
    emit(LDeclineOffer());

    final declineOfferEither = await _offerServices.declineOffer(propertyId: projectId);

    declineOfferEither.fold(
      (failure) {
        print('#log : FDeclineOffer =>');
        print(failure.errorMessage);
        emit(FDeclineOffer(failure: failure));
      },
      (data) {
        print('#log : SDeclineOffer => ${data.success}');

        emit(SDeclineOffer(result: data));
      },
    );
  }

  Future<void> acceptOffer(String projectId) async {
    emit(LAcceptOffer());

    final acceptOfferEither = await _offerServices.acceptOffer(propertyId: projectId);

    acceptOfferEither.fold(
      (failure) {
        print('#log : FAcceptOffer =>');
        print(failure.errorMessage);
        emit(FAcceptOffer(failure: failure));
      },
      (data) {
        print('#log : SAcceptOffer => ${data.success}');
        emit(SAcceptOffer(result: data));
      },
    );
  }

  Future<void> placeOffer(String projectId, String offer) async {
    emit(LPlaceOffer());

    final acceptOfferEither = await _offerServices.placeOffer(planID: projectId, client_offer: offer);

    acceptOfferEither.fold(
      (failure) {
        print('#log : FAcceptOffer =>');
        print(failure.errorMessage);
        emit(FPlaceOffer(failure: failure));
      },
      (data) {
        print('#log : SAcceptOffer => ${data.success}');
        emit(SPlaceOffer(result: data));
      },
    );
  }

  Future<void> getPaymentHistory(String projectId) async {
    emit(LPaymentHistory());
    PaymentHistoyRequestParams requestParams = PaymentHistoyRequestParams(property_id: int.parse(projectId));
    final declineOfferEither = await _offerServices.getPaymentHistory(requestParams: requestParams);

    declineOfferEither.fold(
      (failure) {
        print('#log : FPaymentHistory =>');
        print(failure.errorMessage);
        emit(FPaymentHistory(failure: failure));
      },
      (data) {
        print('#log : SPaymentHistory => ${data.paymentHistoryModel.length})}');

        emit(SPaymentHistory(result: data));
      },
    );
  }
}
