class PopularBuildingLocationResponseModel {
  List<Locations>? locations;

  PopularBuildingLocationResponseModel({this.locations});

  factory PopularBuildingLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return PopularBuildingLocationResponseModel(
        locations: json['locations'] != null
            ? List<Locations>.from((json['locations'] as List<dynamic>).map((e) => Locations.fromJson(e)))
            : []);
  }
}

class Locations {
  String buildingName;
  String latlng;

  Locations({required this.buildingName, required this.latlng});

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(buildingName: json['building_name'], latlng: json['latlng']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building_name'] = this.buildingName;
    data['latlng'] = this.latlng;
    return data;
  }
}
