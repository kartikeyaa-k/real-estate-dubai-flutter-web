import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/services/verification_status_services/verification_status_service.dart';

part 'verification_hack_state.dart';

class VerificationHackCubit extends Cubit<VerificationHackState> {
  VerificationHackCubit(this._verificationStatusService) : super(VerificationHackState());
  final VerificationStatusService _verificationStatusService;

  completeVerification(String propertyId) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final responseEither = await _verificationStatusService.completeVerification(propertyId: propertyId);

    responseEither.fold(
      (failure) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (success) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      },
    );
  }
}
