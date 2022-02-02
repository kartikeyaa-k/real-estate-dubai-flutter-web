import 'new_requested_service_model.dart';

class AddServiceAgencyRequestParams {
  // ignore: non_constant_identifier_names
  // keeping the name same as in the api to avoid mistakes
  String companyName;
  String typeOfOrganization;
  String registeredOfficeAddress;
  List<int> emirateIds;
  String serviceProviderType;
  List<int> chosenServices;
  List<NewRequestedServiceRequestParams>? newRequestedServices;

  // ignore: non_constant_identifier_names
  AddServiceAgencyRequestParams(
      {required this.companyName,
      required this.typeOfOrganization,
      required this.registeredOfficeAddress,
      required this.emirateIds,
      required this.serviceProviderType,
      required this.chosenServices,
      this.newRequestedServices});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_name'] = this.companyName;
    data['type_of_organization'] = this.typeOfOrganization;
    data['registered_office_address'] = this.registeredOfficeAddress;
    data['emirate_ids'] = this.emirateIds;
    data['service_provider_type'] = this.serviceProviderType;
    data['chosen_services'] = this.chosenServices;
    if (this.newRequestedServices != null) {
      data['new_requested_services'] = this.newRequestedServices!.map((v) => v.toJson()).toList();
    } else {
      data['new_requested_services'] = [];
    }
    return data;
  }
}
