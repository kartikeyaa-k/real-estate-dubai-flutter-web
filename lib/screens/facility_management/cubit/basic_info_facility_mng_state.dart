part of 'basic_info_facility_mng_cubit.dart';

class BasicInfoFacilityMngState extends Equatable {
  const BasicInfoFacilityMngState({
    this.firstName = const Name.pure(),
    this.lastName = const Name.pure(),
    this.emailId = const Email.pure(),
    this.mobileNumber = "",
    this.mobileValid = false,
    this.basicFormStatus = FormzStatus.invalid,
    this.typeOfOrganization = "",
    this.companyName = const Name.pure(),
    this.companyFormStatus = FormzStatus.invalid,
    this.numberOfProperties = 0,
    this.listingType = "",
    this.failureMessage = "",
    this.selectedLocations = const [],
    this.propertyLocationModel = PropertyLocationListModel.empty,
    this.propertyFormStatus = FormzStatus.invalid,
    this.annualMaintenanceContract = const [],
    this.amcFormStatus = FormzStatus.valid,
    this.status = FormzStatus.invalid,
  });

  final Name firstName;
  final Name lastName;
  final Email emailId;
  final String mobileNumber;
  final bool mobileValid;
  final FormzStatus basicFormStatus;

  final String typeOfOrganization;
  final Name companyName;
  final FormzStatus companyFormStatus;

  final int numberOfProperties;
  final String listingType;
  final String failureMessage;
  final List<PropertyLocationModel?> selectedLocations;
  final PropertyLocationListModel propertyLocationModel;
  final FormzStatus propertyFormStatus;

  final List<String> annualMaintenanceContract;
  final FormzStatus amcFormStatus;

  final FormzStatus status;

  @override
  List<Object> get props {
    return [
      firstName,
      lastName,
      emailId,
      mobileNumber,
      mobileValid,
      basicFormStatus,
      typeOfOrganization,
      companyName,
      companyFormStatus,
      numberOfProperties,
      listingType,
      failureMessage,
      selectedLocations,
      propertyLocationModel,
      propertyFormStatus,
      annualMaintenanceContract,
      amcFormStatus,
      status,
    ];
  }

  BasicInfoFacilityMngState copyWith({
    Name? firstName,
    Name? lastName,
    Email? emailId,
    String? mobileNumber,
    bool? mobileValid,
    FormzStatus? basicFormStatus,
    String? typeOfOrganization,
    Name? companyName,
    FormzStatus? companyFormStatus,
    int? numberOfProperties,
    String? listingType,
    String? failureMessage,
    List<PropertyLocationModel?>? selectedLocations,
    PropertyLocationListModel? propertyLocationModel,
    FormzStatus? propertyFormStatus,
    List<String>? annualMaintenanceContract,
    FormzStatus? amcFormStatus,
    FormzStatus? status,
  }) {
    return BasicInfoFacilityMngState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailId: emailId ?? this.emailId,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      mobileValid: mobileValid ?? this.mobileValid,
      basicFormStatus: basicFormStatus ?? this.basicFormStatus,
      typeOfOrganization: typeOfOrganization ?? this.typeOfOrganization,
      companyName: companyName ?? this.companyName,
      companyFormStatus: companyFormStatus ?? this.companyFormStatus,
      numberOfProperties: numberOfProperties ?? this.numberOfProperties,
      listingType: listingType ?? this.listingType,
      failureMessage: failureMessage ?? this.failureMessage,
      selectedLocations: selectedLocations ?? this.selectedLocations,
      propertyLocationModel: propertyLocationModel ?? this.propertyLocationModel,
      propertyFormStatus: propertyFormStatus ?? this.propertyFormStatus,
      annualMaintenanceContract: annualMaintenanceContract ?? this.annualMaintenanceContract,
      amcFormStatus: amcFormStatus ?? this.amcFormStatus,
      status: status ?? this.status,
    );
  }
}
