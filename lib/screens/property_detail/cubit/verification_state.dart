part of 'verification_cubit.dart';

class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object> get props => [];
}

class VerificationInit extends VerificationState {
  const VerificationInit();
}

//Loading
class LVerification extends VerificationState {
  const LVerification();
}

//Failed
class FVerification extends VerificationState {
  final Failure failure;
  const FVerification({required this.failure});
}

//Success
class SVerification extends VerificationState {
  final VerificationStatusResponseModel result;
  const SVerification({required this.result});
}
