import 'package:real_estate_portal/models/response_models/timeslot_response_models/timeslot_model.dart';

import 'visit_details_model.dart';

class BookStatusResponseModel {
  final String? status;
  final String? sub_status;
  final VisitDetailsModel? visit_details;
  final String? contract_link;
  final String? offered_price;
  final String? actual_price;
  final String? due_date;

  const BookStatusResponseModel(
      {this.status,
      this.sub_status,
      this.visit_details,
      this.contract_link,
      this.offered_price,
      this.actual_price,
      this.due_date});

  static const empty = BookStatusResponseModel(
      status: "",
      sub_status: "",
      visit_details: VisitDetailsModel(from_time: "", to_time: "", scheduled_date: ""),
      contract_link: "",
      offered_price: "",
      actual_price: "",
      due_date: "");

  factory BookStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return BookStatusResponseModel(
        status: json['status'],
        sub_status: json['sub_status'],
        visit_details: VisitDetailsModel.fromJson(json['visit_details']),
        contract_link: json['contract_link'],
        offered_price: json['offered_price'],
        actual_price: json['actual_price'],
        due_date: json['due_date']);
  }
}
