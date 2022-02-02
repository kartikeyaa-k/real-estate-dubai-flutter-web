class EmirateModel {
  int emirate_id;
  String? emirate_name;
  String? description;
  String image;

  EmirateModel({required this.emirate_id, this.emirate_name, this.description, required this.image});

  factory EmirateModel.fromJson(Map<String, dynamic> json) {
    return EmirateModel(
        emirate_id: json['emirate_id'],
        emirate_name: json['emirate_name'] != null ? json['emirate_name'] : "",
        description: json['description'] != null ? json['description'] : "",
        image: json['image']);
  }
}
