import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';

class TimeSlotResponseModel {
  bool success;
  List<TimeSlotModel>? data;

  TimeSlotResponseModel({required this.success, this.data});

  factory TimeSlotResponseModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponseModel(
        success: json['success'],
        data: json['Data'] != null
            ? List<TimeSlotModel>.from((json['Data'] as List<dynamic>)
                .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>)))
            : null);
  }
}
