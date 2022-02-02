part of 'quoted_service_cubit.dart';

class QuotedServiceState extends Equatable {
  const QuotedServiceState({
    this.status = FormzStatus.pure,
    this.failureMessage = "",
    this.services = const [],
  });

  final FormzStatus status;
  final String failureMessage;
  final List<QuotedServiceModel> services;

  @override
  List<Object> get props => [status, failureMessage, services];

  QuotedServiceState copyWith({
    FormzStatus? status,
    String? failureMessage,
    List<QuotedServiceModel>? services,
  }) {
    return QuotedServiceState(
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      services: services ?? this.services,
    );
  }
}
