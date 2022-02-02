part of 'home_filter_bloc.dart';

abstract class HomeFilterEvent extends Equatable {
  const HomeFilterEvent();

  @override
  List<Object?> get props => [];
}

class InitHomeFilter extends HomeFilterEvent {}

/// triggered when the search parameter changes.
class SearchParamChanged extends HomeFilterEvent {
  final String searchParam;
  const SearchParamChanged({
    required this.searchParam,
  });

  @override
  List<Object?> get props => [...super.props, searchParam];
}

class FindPropertyPressed extends HomeFilterEvent {
  final String searchKeywordList;
  final int propertyTypeId;
  final int minPrice;
  final int maxPrice;
  final String furnishing;
  final int minArea;
  final int maxArea;
  final String keywords;

  const FindPropertyPressed({
    required this.searchKeywordList,
    required this.propertyTypeId,
    required this.minPrice,
    required this.maxPrice,
    required this.furnishing,
    required this.minArea,
    required this.maxArea,
    required this.keywords,
  });

  @override
  List<Object?> get props =>
      [searchKeywordList, propertyTypeId, minPrice, maxPrice, furnishing, minArea, maxArea, keywords];
}
