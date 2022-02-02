import 'description_model.dart';
import 'hero_text.dart';

class CoverPageModel {
  HeroTextModel? heroText;
  DescriptionTextModel? descriptionText;
  String logoUrl;
  int projectId;
  String heroImageUrl;
  String? brochureUrl;

  CoverPageModel(
      {this.heroText,
      this.descriptionText,
      required this.logoUrl,
      required this.projectId,
      required this.heroImageUrl,
      this.brochureUrl});

  factory CoverPageModel.fromJson(Map<String, dynamic> json) {
    return CoverPageModel(
        heroText: json['hero_text'] != null ? new HeroTextModel.fromJson(json['hero_text']) : null,
        descriptionText: json['description_text'] != null ? new DescriptionTextModel.fromJson(json['description_text']) : null,
        logoUrl: json['logo_url'],
        projectId: json['project_id'],
        heroImageUrl: json['hero_image_url'],
        brochureUrl: json['brochure_url']);
  }
}
