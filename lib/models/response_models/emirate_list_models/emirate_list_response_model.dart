import 'emirate_model.dart';

class EmiratesListResponseModel {
  bool success;
  List<EmirateModel>? data;
  int total;

  EmiratesListResponseModel({required this.success, this.data, required this.total});

  factory EmiratesListResponseModel.fromJson(Map<String, dynamic> json) {
    return EmiratesListResponseModel(
        success: json['success'],
        data: json['Data'] != null
            ? List<EmirateModel>.from(
                (json['Data'] as List<dynamic>).map((e) => EmirateModel.fromJson(e as Map<String, dynamic>)))
            : null,
        total: json['total']);
  }
}
