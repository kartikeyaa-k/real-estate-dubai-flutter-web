import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/payment_history_model.dart';
import 'package:real_estate_portal/models/request_models/verification_request_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/accept_response_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/decline_response_model.dart';
import 'package:real_estate_portal/models/response_models/payment_history_response_models/payment_history_response_model.dart';
import 'package:real_estate_portal/models/response_models/verification_status_response_models/verification_status_response_model.dart';
import 'package:real_estate_portal/services/offer_services/offer_services.dart';
import 'package:real_estate_portal/services/verification_status_services/verification_status_service.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationStatusService _verificationStatusService;

  VerificationCubit({required VerificationStatusService verificationStatusService})
      : _verificationStatusService = verificationStatusService,
        super(VerificationInit());

  Future<void> getStatus(String projectId) async {
    emit(LVerification());
    VerificationStatusRequestParams requestParams = VerificationStatusRequestParams(property_id: int.parse(projectId));
    final declineOfferEither = await _verificationStatusService.getVerificationStatus(requestParam: requestParams);

    declineOfferEither.fold(
      (failure) {
        print('#log : FVerification =>');
        print(failure.errorMessage);
        emit(FVerification(failure: failure));
      },
      (data) {
        print('#log : SVerification => ${data.verificationStatus}');

        emit(SVerification(result: data));
      },
    );
  }
}
