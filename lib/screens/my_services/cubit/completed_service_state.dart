part of 'completed_service_cubit.dart';

class CompletedServiceState extends Equatable {
  const CompletedServiceState({
    this.status = FormzStatus.pure,
    this.serviceIsSatisfiedStatus = FormzStatus.pure,
    this.failureMessage = "",
    this.services = const [],
  });

  final FormzStatus status;
  final FormzStatus serviceIsSatisfiedStatus;

  final String failureMessage;
  final List<CompletedServiceModel> services;

  @override
  List<Object> get props => [status, serviceIsSatisfiedStatus, failureMessage, services];

  CompletedServiceState copyWith({
    FormzStatus? status,
    FormzStatus? serviceIsSatisfiedStatus,
    String? failureMessage,
    List<CompletedServiceModel>? services,
  }) {
    return CompletedServiceState(
      status: status ?? this.status,
      serviceIsSatisfiedStatus: serviceIsSatisfiedStatus ?? this.serviceIsSatisfiedStatus,
      failureMessage: failureMessage ?? this.failureMessage,
      services: services ?? this.services,
    );
  }
}
