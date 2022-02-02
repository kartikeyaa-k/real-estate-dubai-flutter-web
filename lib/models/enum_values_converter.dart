class EnumValues<T> {
  final Map<String, T> map;

  const EnumValues(this.map);

  Map<T, String>? get reverse {
    Map<T, String>? reverseMap;
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
