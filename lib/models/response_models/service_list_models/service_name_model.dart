class ServiceNameModel {
  String ar;
  String en;

  ServiceNameModel({required this.ar, required this.en});

  factory ServiceNameModel.fromJson(Map<String, dynamic> json) {
    return ServiceNameModel(ar: json['ar'], en: json['en']);
  }
}
