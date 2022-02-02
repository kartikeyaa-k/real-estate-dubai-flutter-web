part of 'booked_service_cubit.dart';

class BookedServiceState extends Equatable {
  const BookedServiceState({
    this.status = FormzStatus.pure,
    this.failureMessage = "",
    this.services = const [],
    this.formStatus = FormzStatus.pure,
    this.formFailureMessage = "",
    this.fromTime = "",
    this.toTime = "",
    this.date,
  });

  final FormzStatus status;
  final String failureMessage;
  final List<BookedServiceModel> services;

  final FormzStatus formStatus;
  final String formFailureMessage;
  final String fromTime;
  final String toTime;
  final DateTime? date;

  @override
  List<Object?> get props => [status, failureMessage, services, formStatus, formFailureMessage, fromTime, toTime, date];

  BookedServiceState copyWith({
    FormzStatus? status,
    String? failureMessage,
    List<BookedServiceModel>? services,
    FormzStatus? formStatus,
    String? formFailureMessage,
    String? fromTime,
    String? toTime,
    DateTime? date,
  }) {
    return BookedServiceState(
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      services: services ?? this.services,
      formStatus: formStatus ?? this.formStatus,
      formFailureMessage: formFailureMessage ?? this.formFailureMessage,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      date: date ?? this.date,
    );
  }
}
