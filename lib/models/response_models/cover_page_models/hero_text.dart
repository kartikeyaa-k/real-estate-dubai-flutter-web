class HeroTextModel {
  String ar;
  String en;

  HeroTextModel({required this.ar, required this.en});

  factory HeroTextModel.fromJson(Map<String, dynamic> json) {
    return HeroTextModel(ar: json['ar'], en: json['en']);
  }
}
