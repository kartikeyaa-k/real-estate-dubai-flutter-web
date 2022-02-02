part of 'verification_hack_cubit.dart';

class VerificationHackState extends Equatable {
  const VerificationHackState({
    this.status = FormzStatus.pure,
    this.failureMessage = "",
  });

  final FormzStatus status;
  final String failureMessage;

  @override
  List<Object> get props => [status, failureMessage];

  VerificationHackState copyWith({
    FormzStatus? status,
    String? failureMessage,
  }) {
    return VerificationHackState(
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }
}
