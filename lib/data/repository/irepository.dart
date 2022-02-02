import 'package:real_estate_portal/models/home_page_model/property_types_model.dart';
import 'package:real_estate_portal/models/home_page_model/suggest_places_model.dart';

abstract class IRepository {
  // Future<int> getAppLanguage();

  // Future<void> setAppLanguage(
  //   int value,
  // );

  // Future<FilterResults> getFilterResult(
  //   String? keywords,
  //   int? minPrice,
  //   int? maxPrice,
  //   String? pay,
  //   int? minArea,
  //   int? maxArea,
  //   int? minBedrooms,
  //   int? maxBedrooms,
  //   int? minBathrooms,
  //   int? maxBathrooms,
  // );

  // Future<HomePageModel> getHomeData();

  Future<SuggestPlacesModel> getSuggestPlaces(String? searchParam);

  // Future<AmenitiesModel> getAmenities();

  // Future<PropertyTypesModel> getPropertyTypes();
}
