part of 'service_cubit.dart';

class ServiceState extends Equatable {
  const ServiceState({
    this.failureMessage = "",
    this.otherServiceStatus = FormzStatus.pure,
    this.facilityServiceStatus = FormzStatus.pure,
    this.serviceRequestStatus = FormzStatus.pure,
    this.otherServices = const [],
    this.facilityServices = const [],
  });

  final String failureMessage;
  final FormzStatus otherServiceStatus;
  final FormzStatus facilityServiceStatus;
  final FormzStatus serviceRequestStatus;

  final List<ServiceMainModel> otherServices;
  final List<ServiceMainModel> facilityServices;

  @override
  List<Object> get props {
    return [
      failureMessage,
      otherServiceStatus,
      facilityServiceStatus,
      serviceRequestStatus,
      otherServices,
      facilityServices,
    ];
  }

  ServiceState copyWith({
    String? failureMessage,
    FormzStatus? otherServiceStatus,
    FormzStatus? facilityServiceStatus,
    FormzStatus? serviceRequestStatus,
    List<ServiceMainModel>? otherServices,
    List<ServiceMainModel>? facilityServices,
  }) {
    return ServiceState(
      failureMessage: failureMessage ?? this.failureMessage,
      otherServiceStatus: otherServiceStatus ?? this.otherServiceStatus,
      facilityServiceStatus: facilityServiceStatus ?? this.facilityServiceStatus,
      serviceRequestStatus: serviceRequestStatus ?? this.serviceRequestStatus,
      otherServices: otherServices ?? this.otherServices,
      facilityServices: facilityServices ?? this.facilityServices,
    );
  }
}
