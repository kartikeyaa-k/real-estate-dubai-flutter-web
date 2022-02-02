import 'package:real_estate_portal/data/http_helper/Ihttp_helper.dart';
import 'package:real_estate_portal/data/prefs_helper/iprefs_helper.dart';
import 'package:real_estate_portal/data/repository/irepository.dart';
import 'package:real_estate_portal/models/home_page_model/suggest_places_model.dart';
import 'package:real_estate_portal/models/home_page_model/property_types_model.dart';

class Repository implements IRepository {
  IHttpHelper _iHttpHelper;
  IPrefsHelper _iPrefsHelper;

  Repository(
    this._iHttpHelper,
    this._iPrefsHelper,
  );

  // @override
  // Future<int> getAppLanguage() async {
  //   return await _iPrefsHelper.getAppLanguage();
  // }

  // @override
  // Future<void> setAppLanguage(
  //   int value,
  // ) async {
  //   await _iPrefsHelper.setAppLanguage(value);
  // }

  @override
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
  // ) async {
  //   final filterResult = await _iHttpHelper.getFilterResult(
  //     keywords,
  //     minPrice,
  //     maxPrice,
  //     pay,
  //     minArea,
  //     maxArea,
  //     minBedrooms,
  //     maxBedrooms,
  //     minBathrooms,
  //     maxBathrooms,
  //   );
  //   return filterResult;
  // }

  // @override
  // Future<HomePageModel> getHomeData() async {
  //   final homePage = await _iHttpHelper.getHomeData();
  //   return homePage;
  // }

  // @override
  // Future<AmenitiesModel> getAmenities() async {
  //   final amenities = await _iHttpHelper.getAmenities();
  //   return amenities;
  // }

  // @override
  // Future<PropertyTypesModel> getPropertyTypes() async {
  //   final propertyTypes = await _iHttpHelper.getPropertyTypes();
  //   return propertyTypes;
  // }

  @override
  Future<SuggestPlacesModel> getSuggestPlaces(
    String? searchParam,
  ) async {
    final suggestPlaces = await _iHttpHelper.getSuggestPlaces(searchParam);
    return suggestPlaces;
  }
}
