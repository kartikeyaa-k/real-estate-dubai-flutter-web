import 'dart:convert';

import 'package:equatable/equatable.dart';

SuggestPlacesModel suggestPlacesModelFromJson(String str) => SuggestPlacesModel.fromJson(json.decode(str));

String suggestPlacesModelToJson(SuggestPlacesModel data) => json.encode(data.toJson());

class PlacesResultModel extends Equatable {
  final int id;
  final String category;
  final String name;

  PlacesResultModel({
    required this.id,
    required this.category,
    required this.name,
  });

  factory PlacesResultModel.fromJson(Map<String, dynamic> json) => PlacesResultModel(
        id: json["id"],
        category: json["category"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "name": name,
      };

  @override
  List<Object?> get props => [id, category, name];

  @override
  String toString() {
    return name;
  }
}

class SuggestPlacesModel extends Equatable {
  final bool success;
  final List<PlacesResultModel> result;

  const SuggestPlacesModel({
    required this.success,
    required this.result,
  });

  static const empty = SuggestPlacesModel(success: false, result: const []);

  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory SuggestPlacesModel.fromJson(Map<String, dynamic> json) => SuggestPlacesModel(
        success: json["success"],
        result: List<PlacesResultModel>.from(json["result"].map((x) => PlacesResultModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [success, result];
}
