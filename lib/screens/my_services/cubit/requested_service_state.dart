part of 'requested_service_cubit.dart';

class RequestedServiceState extends Equatable {
  const RequestedServiceState({
    this.status = FormzStatus.pure,
    this.failureMessage = "",
    this.requestedServices = const [],
  });

  final FormzStatus status;
  final String failureMessage;
  final List<RequestedServiceModel> requestedServices;

  @override
  List<Object> get props => [status, failureMessage, requestedServices];

  RequestedServiceState copyWith({
    FormzStatus? status,
    String? failureMessage,
    List<RequestedServiceModel>? requestedServices,
  }) {
    return RequestedServiceState(
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      requestedServices: requestedServices ?? this.requestedServices,
    );
  }
}
