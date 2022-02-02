import 'organisation_types_model.dart';

class OrganisationTypesResponseModel {
  bool success;
  List<OrganisationTypesModel>? list;

  OrganisationTypesResponseModel({required this.success, this.list});

  factory OrganisationTypesResponseModel.fromJson(Map<String, dynamic> json) {
    return OrganisationTypesResponseModel(
        success: json['success'],
        list: json['list'] != null
            ? List<OrganisationTypesModel>.from(
                (json['list'] as List<dynamic>).map((e) => OrganisationTypesModel.fromJson(e as Map<String, dynamic>)))
            : null);
  }
}
