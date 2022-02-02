part of 'phone_login_cubit.dart';

enum PhoneAuthStatus {
  pure,
  phoneValid,
  phoneInvalid,
  phoneSubmissionInProgress,
  phoneSubmissionFailure,
  phoneSubmissionSuccess,
  otpValid,
  otpInvalid,
  otpSubmissionInProgress,
  otpSubmissionFailure,
  otpSubmissionSuccess,
}

class PhoneLoginState extends Equatable {
  const PhoneLoginState({
    this.phone = "",
    this.status = PhoneAuthStatus.pure,
    this.otp = const OTP.pure(),
    this.confirmationResult,
    this.userCredential,
  });

  final String phone;
  final PhoneAuthStatus status;
  final OTP otp;
  final ConfirmationResult? confirmationResult;
  final UserCredential? userCredential;

  @override
  List<Object?> get props {
    return [
      phone,
      status,
      otp,
      confirmationResult,
      userCredential,
    ];
  }

  PhoneLoginState copyWith({
    String? phone,
    PhoneAuthStatus? status,
    OTP? otp,
    ConfirmationResult? confirmationResult,
    UserCredential? userCredential,
  }) {
    return PhoneLoginState(
      phone: phone ?? this.phone,
      status: status ?? this.status,
      otp: otp ?? this.otp,
      confirmationResult: confirmationResult ?? this.confirmationResult,
      userCredential: userCredential ?? this.userCredential,
    );
  }
}
