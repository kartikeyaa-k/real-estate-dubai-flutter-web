import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../../data/http_helper/Ihttp_helper.dart';
import '../../../models/facility_management_model/property_location_model.dart';

part 'basic_info_facility_mng_state.dart';

class BasicInfoFacilityMngCubit extends Cubit<BasicInfoFacilityMngState> {
  final IHttpHelper httpHelper;
  BasicInfoFacilityMngCubit(this.httpHelper) : super(BasicInfoFacilityMngState());

  /*--------------------------------------------*/

  initBasicInfoForm() async {
    String? _displayName = FirebaseAuth.instance.currentUser?.displayName;
    String? _emailName = FirebaseAuth.instance.currentUser?.email;

    final _name = Name.dirty(_displayName?.split(',').first ?? "");
    final _lastName = Name.dirty(_displayName?.split(',').last ?? "");
    final _email = Email.dirty(_emailName ?? "");

    emit(state.copyWith(firstName: _name, lastName: _lastName, emailId: _email));

    final locationEither = await httpHelper.getPropertyLocation();

    locationEither.fold(
      (failure) => emit(state.copyWith(failureMessage: failure.errorMessage)),
      (propertyLocationModel) => emit(state.copyWith(propertyLocationModel: propertyLocationModel)),
    );
  }

  /*--------------------------------------------*/

  onFirstNameChanged(String value) {
    final firstName = Name.dirty(value);
    FormzStatus status = Formz.validate([firstName, state.lastName, state.emailId]);
    if (!state.mobileValid) status = FormzStatus.invalid;

    emit(state.copyWith(firstName: firstName, basicFormStatus: status));
  }

  /*--------------------------------------------*/

  onLastNameChanged(String value) {
    final lastName = Name.dirty(value);
    FormzStatus status = Formz.validate([state.firstName, lastName, state.emailId]);
    if (!state.mobileValid) status = FormzStatus.invalid;

    emit(state.copyWith(lastName: lastName, basicFormStatus: status));
  }

  /*--------------------------------------------*/

  onEmailChanged(String value) {
    final email = Email.dirty(value);
    FormzStatus status = Formz.validate([state.firstName, state.lastName, email]);
    if (!state.mobileValid) status = FormzStatus.invalid;

    emit(state.copyWith(emailId: email, basicFormStatus: status));
  }

  /*--------------------------------------------*/

  phoneNumberChanged(String value) {
    emit(state.copyWith(mobileNumber: value));
  }

  /*--------------------------------------------*/

  phoneNumberValidate(bool value) {
    FormzStatus status = Formz.validate([state.firstName, state.lastName, state.emailId]);
    if (!value) status = FormzStatus.invalid;

    emit(state.copyWith(mobileValid: value, basicFormStatus: status));
  }

  /*--------------------------------------------*/

  typeOfOrganizationSelected(String value) {
    FormzStatus status;
    if (value == 'agency') {
      status = Formz.validate([state.companyName]);
      print("company validation $status");
    } else {
      status = value == "single_owner" ? FormzStatus.valid : FormzStatus.invalid;
    }
    emit(state.copyWith(typeOfOrganization: value, companyFormStatus: status));
  }

  /*--------------------------------------------*/

  companyNameChanged(String value) {
    FormzStatus status;
    final companyName = Name.dirty(value);
    if (state.typeOfOrganization == 'agency') {
      status = Formz.validate([companyName]);
      print('#logn : compan name : status : $status');
      emit(state.copyWith(companyFormStatus: status, companyName: companyName));
    } else {
      status = state.typeOfOrganization == "single_owner" ? FormzStatus.valid : FormzStatus.invalid;
      emit(state.copyWith(companyFormStatus: status));
    }
  }

  /*--------------------------------------------*/

  numberofPropertiesChanged(String value) {
    int? numberOfProperty = int.tryParse(value);
    FormzStatus status;
    if (numberOfProperty != null &&
        numberOfProperty > 0 &&
        (state.listingType == "RENT" || state.listingType == "SALE" || state.listingType == "BOTH") &&
        state.selectedLocations.length > 0) {
      status = FormzStatus.valid;
    } else {
      status = FormzStatus.invalid;
    }
    emit(state.copyWith(numberOfProperties: numberOfProperty, propertyFormStatus: status));
  }

  /*--------------------------------------------*/

  selectPropertyLocation(List<PropertyLocationModel?> value) {
    FormzStatus status;
    if (state.numberOfProperties > 0 &&
        (state.listingType == "RENT" || state.listingType == "SALE" || state.listingType == "BOTH") &&
        state.selectedLocations.length > 0) {
      status = FormzStatus.valid;
    } else {
      status = FormzStatus.invalid;
    }
    emit(state.copyWith(selectedLocations: value, propertyFormStatus: status));
  }

  /*--------------------------------------------*/

  selectListingTypeRentChanged(bool isRentListingType, bool isSaleListingType) {
    String listingType = "";
    FormzStatus status;
    if (isRentListingType && isSaleListingType) {
      listingType = "BOTH";
    } else if (isRentListingType && !isSaleListingType) {
      listingType = "RENT";
    } else if (!isRentListingType && isSaleListingType) {
      listingType = "SALE";
    }

    if (state.numberOfProperties > 0 &&
        (listingType == "RENT" || listingType == "SALE" || listingType == "BOTH") &&
        state.selectedLocations.length > 0) {
      status = FormzStatus.valid;
    } else {
      status = FormzStatus.invalid;
    }
    emit(state.copyWith(listingType: listingType, propertyFormStatus: status));
  }

  /*--------------------------------------------*/

  annualMaintainenceContractChanged({
    required bool isFree,
    required bool isBasic,
    required bool isStandard,
    required bool isPremium,
  }) {
    List<String> annualMaintenanceContract = [];
    FormzStatus status = FormzStatus.valid;
    if (isFree) annualMaintenanceContract.add("FREE");
    if (isBasic) annualMaintenanceContract.add("BASIC");
    if (isStandard) annualMaintenanceContract.add("STANDARD");
    if (isPremium) annualMaintenanceContract.add("PREMIUM");
    if (annualMaintenanceContract.length > 0) {
      status = FormzStatus.valid;
      print('#log amcFormStatus: $status');
    }

    emit(state.copyWith(amcFormStatus: status, annualMaintenanceContract: annualMaintenanceContract));
  }

  /*--------------------------------------------*/

  submitForm() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    state.selectedLocations.removeWhere((element) => element == null);

    var addCompanyEither = await httpHelper.addCompany(
      companyName: state.companyName.value,
      typeOfOrganization: state.typeOfOrganization,
      numberOfProperties: state.numberOfProperties,
      locationProperties: state.selectedLocations.map((e) => e!.toJson()).toList(),
      type: state.listingType,
      amc: state.annualMaintenanceContract,
    );

    addCompanyEither.fold(
      (failure) => emit(state.copyWith(failureMessage: failure.errorMessage, status: FormzStatus.submissionFailure)),
      (success) => emit(state.copyWith(status: FormzStatus.submissionSuccess)),
    );
  }
}
