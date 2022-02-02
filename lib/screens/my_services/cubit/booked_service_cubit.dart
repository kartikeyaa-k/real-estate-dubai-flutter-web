import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

import '../../../models/response_models/my_service_models/booked_service_model.dart';
import '../../../services/my_services/my_services_service.dart';

part 'booked_service_state.dart';

class BookedServiceCubit extends Cubit<BookedServiceState> {
  BookedServiceCubit(this.myServicesService) : super(BookedServiceState());

  final MyServicesService myServicesService;

  loadBookedServices() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final responseEither = await myServicesService.getBookedServices();

    responseEither.fold(
      (failure) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (bookedService) {
        emit(
          state.copyWith(status: FormzStatus.submissionSuccess, services: bookedService.data),
        );
      },
    );
  }

  /*--------------------------------------------*/

  toTimeEntered(String? toTime) {
    if (toTime == null) return;
    emit(state.copyWith(toTime: toTime));
  }

  /*--------------------------------------------*/

  fromTimeEntered(String? fromTime) {
    if (fromTime == null) return;
    emit(state.copyWith(fromTime: fromTime));
  }

  /*--------------------------------------------*/

  dateEntered(DateTime date) {
    emit(state.copyWith(date: date));
  }

  /*--------------------------------------------*/

  rescheduleBookedService(int serviceRequestId) async {
    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));

    if (state.fromTime.isEmpty) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure, formFailureMessage: "Please select from time."));
      return;
    }

    if (state.toTime.isEmpty) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure, formFailureMessage: "Please select to time."));
      return;
    }

    if (state.date == null) {
      emit(
          state.copyWith(formStatus: FormzStatus.submissionFailure, formFailureMessage: "Please select a valid date."));
      return;
    }

    final responseEither = await myServicesService.addServiceTimeSlot(
      fromTime: state.fromTime,
      toTime: state.toTime,
      date: state.date!.toIso8601String(),
      serviceRequestId: serviceRequestId,
    );

    responseEither.fold(
      (failure) {
        emit(state.copyWith(formStatus: FormzStatus.submissionFailure, formFailureMessage: failure.errorMessage));
      },
      (success) {
        emit(state.copyWith(formStatus: FormzStatus.submissionSuccess));
      },
    );
  }

  /*--------------------------------------------*/

  resetRescheduleState() {
    emit(state.copyWith(formStatus: FormzStatus.pure, failureMessage: ""));
  }
}
