import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/models/response_models/my_service_models/completed_service_model.dart';
import 'package:real_estate_portal/services/my_services/my_services_service.dart';

part 'completed_service_state.dart';

class CompletedServiceCubit extends Cubit<CompletedServiceState> {
  CompletedServiceCubit(this.myServicesService) : super(CompletedServiceState());

  final MyServicesService myServicesService;

  loadCompletedServices() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final responseEither = await myServicesService.getCompleteServices();

    responseEither.fold(
      (failure) {
        emit(state.copyWith(status: FormzStatus.submissionFailure, failureMessage: failure.errorMessage));
      },
      (completedService) {
        emit(
          state.copyWith(status: FormzStatus.submissionSuccess, services: completedService.data),
        );
      },
    );
  }

  Future<void> tenantSatisfation({required int serviceRequestId, required int isSatisfied}) async {
    emit(state.copyWith(serviceIsSatisfiedStatus: FormzStatus.submissionInProgress));

    final responseEither =
        await myServicesService.isTenantSatisfied(serviceRequestId: serviceRequestId, isSatisfied: isSatisfied);

    responseEither.fold(
      (failure) => emit(state.copyWith(
          serviceIsSatisfiedStatus: FormzStatus.submissionFailure, failureMessage: failure.errorMessage)),
      (result) => emit(state.copyWith(serviceIsSatisfiedStatus: FormzStatus.submissionSuccess)),
    );
  }
}
