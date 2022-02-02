import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_repository/firebase_authentication_repository.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'phone_login_state.dart';

class PhoneLoginCubit extends Cubit<PhoneLoginState> {
  PhoneLoginCubit(FirebaseAuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(PhoneLoginState());

  final FirebaseAuthenticationRepository _authenticationRepository;

  void phoneNumberChanged(String value) async {
    emit(state.copyWith(phone: value));
  }

  void phoneNumberValidate(bool value) {
    emit(state.copyWith(status: value ? PhoneAuthStatus.phoneValid : PhoneAuthStatus.phoneInvalid));
  }

  void phoneNumberSubmitted() async {
    emit(state.copyWith(status: PhoneAuthStatus.phoneSubmissionInProgress));
    try {
      ConfirmationResult confirmationResult = await _authenticationRepository.signInWithPhoneNumber(phone: state.phone);
      emit(state.copyWith(status: PhoneAuthStatus.phoneSubmissionSuccess, confirmationResult: confirmationResult));
    } catch (e) {
      emit(state.copyWith(status: PhoneAuthStatus.phoneSubmissionFailure));
    }
  }

  void onOTPChanged(String value) {
    final otp = OTP.dirty(value);
    FormzStatus formzStatus = Formz.validate([otp]);
    PhoneAuthStatus phoneAuthStatus =
        formzStatus == FormzStatus.invalid ? PhoneAuthStatus.otpInvalid : PhoneAuthStatus.otpValid;
    emit(state.copyWith(otp: otp, status: phoneAuthStatus));
  }

  void confirmOTPCode() async {
    emit(state.copyWith(status: PhoneAuthStatus.otpSubmissionInProgress));
    try {
      UserCredential userCredential = await _authenticationRepository.confirmationPhoneVerificationCode(
          code: state.otp.value, confirmationResult: state.confirmationResult!);
      emit(state.copyWith(status: PhoneAuthStatus.otpSubmissionSuccess, userCredential: userCredential));
    } catch (e) {
      emit(state.copyWith(status: PhoneAuthStatus.otpSubmissionFailure));
    }
  }
}
