class OrganisationTypesModel {
  String name;
  String key;

  OrganisationTypesModel({required this.name, required this.key});
  factory OrganisationTypesModel.fromJson(Map<String, dynamic> json) {
    return OrganisationTypesModel(
      name: json['name'],
      key: json['key'],
    );
  }
}
