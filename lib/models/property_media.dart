import 'package:equatable/equatable.dart';

class PropertyMedia extends Equatable {
  const PropertyMedia({
    required this.link,
    required this.isCover,
    required this.id,
  });

  final String link;
  final bool isCover;
  final int id;

  static const empty = PropertyMedia(link: "-", isCover: false, id: 0);
  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  factory PropertyMedia.fromJson(Map<String, dynamic> json) => PropertyMedia(
        link: json["link"],
        isCover: json["is_cover"].toString() == "1",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "is_cover": isCover,
        "id": id,
      };

  @override
  List<Object> get props => [link, isCover, id];
}
