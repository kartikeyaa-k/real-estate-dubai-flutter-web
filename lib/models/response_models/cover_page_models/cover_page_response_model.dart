import 'package:real_estate_portal/models/project_model/project_model.dart';

import 'cover_page_model.dart';

class CoverPageResponseModel {
  bool success;
  CoverPageModel? coverProjectDetails;
  ProjectModel? otherDetails;

  CoverPageResponseModel({required this.success, this.coverProjectDetails, this.otherDetails});

  factory CoverPageResponseModel.fromJson(Map<String, dynamic> json) {
    return CoverPageResponseModel(
        success: json['success'],
        coverProjectDetails:
            json['coverProjectDetails'] != null ? new CoverPageModel.fromJson(json['coverProjectDetails']) : null,
        otherDetails: json['otherDetails'] != null ? new ProjectModel.fromJson(json['otherDetails']) : null);
  }
}
