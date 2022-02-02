import 'package:equatable/equatable.dart';

class LocalizedMap extends Equatable {
  final String ar;
  final String en;
  final Map<String, String>? localizedMap;

  const LocalizedMap({required this.ar, required this.en, required this.localizedMap});

  static const empty = LocalizedMap(ar: "", en: "", localizedMap: null);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory LocalizedMap.fromJson(Map<String, dynamic> json) {
    String ar = json['ar'] ?? "";
    String en = json['en'] ?? "";

    return LocalizedMap(ar: ar, en: en, localizedMap: {"ar": ar, "en": en});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }

  @override
  List<Object?> get props => [ar, en];
}
