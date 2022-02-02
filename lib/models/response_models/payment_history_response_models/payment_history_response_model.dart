class PaymentHistoryModelResponseModel {
  bool success;
  List<PaymentHistoryModel> paymentHistoryModel;

  PaymentHistoryModelResponseModel({required this.success, required this.paymentHistoryModel});

  factory PaymentHistoryModelResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModelResponseModel(
        success: json['success'],
        paymentHistoryModel: json['paymentHistory'] != null
            ? List<PaymentHistoryModel>.from(
                (json['paymentHistory'] as List<dynamic>).map((e) => PaymentHistoryModel.fromJson(e as Map<String, dynamic>)))
            : []);
  }
}

class PaymentHistoryModel {
  String period;
  String? receipt;
  int amountPayable;

  PaymentHistoryModel({required this.period, required this.receipt, required this.amountPayable});

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(period: json['period'], receipt: json['receipt'], amountPayable: json['amountPayable']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['period'] = this.period;
    data['receipt'] = this.receipt;
    data['amountPayable'] = this.amountPayable;
    return data;
  }
}
