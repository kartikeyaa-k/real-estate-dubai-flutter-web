class DescriptionTextModel {
  String ar;
  String en;

  DescriptionTextModel({required this.ar, required this.en});

  factory DescriptionTextModel.fromJson(Map<String, dynamic> json) {
    return DescriptionTextModel(ar: json['ar'], en: json['en']);
  }
}
