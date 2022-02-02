import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/payment_history_model.dart';
import 'package:real_estate_portal/models/response_models/my_properties/booked_properties_response_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/accept_response_model.dart';
import 'package:real_estate_portal/models/response_models/offer_response_models/decline_response_model.dart';
import 'package:real_estate_portal/models/response_models/payment_history_response_models/payment_history_response_model.dart';
import 'package:real_estate_portal/services/offer_services/offer_services.dart';
import 'package:real_estate_portal/services/property_services/property_services.dart';

part 'my_properties_state.dart';

class MyPropertiesCubit extends Cubit<MyPropertiesState> {
  PropertyServices _propertyServices;

  MyPropertiesCubit({required PropertyServices propertyServices})
      : _propertyServices = propertyServices,
        super(MyPropertiesInit());

  Future<void> getBookedProperties() async {
    emit(LBooked());

    final response = await _propertyServices.getBookedProperties();
    
    response.fold(
      (failure) {
        print('#log : FBooked =>');
        print(failure.errorMessage);
        emit(FBooked(failure: failure));
      },
      (data) {
        print('#log : SBooked => ${data.success}');
        emit(SBooked(result: data));
      },
    );
  }

  Future<void> getInProcessProperties() async {
    emit(LInProcess());

    final response = await _propertyServices.getInProcessProperties();

    response.fold(
      (failure) {
        print('#log : FInProcess =>');
        print(failure.errorMessage);
        emit(FInProcess(failure: failure));
      },
      (data) {
        print('#log : SInProcess => ${data.success}');
        emit(SInProcess(result: data));
      },
    );
  }

  Future<void> getSavedProperties() async {
    emit(LSaved());

    final response = await _propertyServices.getSavedProperties();

    response.fold(
      (failure) {
        print('#log : FSaved =>');
        print(failure.errorMessage);
        emit(FSaved(failure: failure));
      },
      (data) {
        print('#log : SSaved => ${data.success}');
        emit(SSaved(result: data));
      },
    );
  }
}
