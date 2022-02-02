import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/error/failure.dart';
import '../../models/home_page_model/suggest_places_model.dart';
import '../../models/property_details_models/property_location_detail_model.dart';
import '../../models/property_details_models/property_model.dart';
import '../../models/response_models/my_properties/booked_properties_response_model.dart';
import '../../screens/property_listing/constants/property_listing_const.dart';

abstract class PropertyServices {
  Future<Either<Failure, PropertyListingListModel>> getSearchFilter(
      {int? minBedrooms,
      int? maxBedrooms,
      int? propertySubTypeId,
      int? minPrice,
      int? maxPrice,
      double? minArea,
      double? maxArea,
      PaymentType? paymentType,
      int? minBathrooms,
      int? maxBathrooms,
      FurnishedType? furnishingType,
      List<int>? amenityIds,
      String? tour,
      List<String>? keywordArray,
      int? limit,
      int? offset,
      List<PlacesResultModel>? locationArray,
      PlanType? planType,
      String? sort});

  Future<Either<Failure, PropertyModel>> getPropertyById(String propertyId);

  Future<Either<Failure, PropertyLocationDetailModel>> getPropertyLocationDetails(LatLng position);

  Future<Either<Failure, PropertyListingListModel>> getCommunityFeaturedProperties(
      {required Map<String, dynamic> params});

  Future<Either<Failure, BookedPropertiesResponseModel>> getBookedProperties();
  Future<Either<Failure, BookedPropertiesResponseModel>> getSavedProperties();
  Future<Either<Failure, BookedPropertiesResponseModel>> getInProcessProperties();

  Future<Either<Failure, bool>> bookmarkProperty(String propertyId);

  Future<Either<Failure, bool>> checkPropertyBookmarkStatus(String propertyId);
}

class PropertyServicesImpl implements PropertyServices {
  final Dio dio;

  PropertyServicesImpl({required this.dio});

  @override
  Future<Either<Failure, PropertyListingListModel>> getSearchFilter({
    int? minBedrooms,
    int? maxBedrooms,
    int? propertySubTypeId,
    int? minPrice,
    int? maxPrice,
    double? minArea,
    double? maxArea,
    PaymentType? paymentType,
    String? keywords,
    int? minBathrooms,
    int? maxBathrooms,
    FurnishedType? furnishingType,
    List<int>? amenityIds,
    String? tour,
    List<String>? keywordArray,
    int? limit = kPropertyPerPage,
    int? offset = 0,
    List<PlacesResultModel>? locationArray,
    PlanType? planType,
    String? sort,
  }) async {
    String url = "search";
    Map<String, dynamic>? queryParameters = {
      "minBedroom": minBedrooms,
      "maxBedroom": maxBedrooms,
      "propertySubTypeId": propertySubTypeId,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "minArea": minArea,
      "maxArea": maxArea,
      "paymentType": jsonEncode(PropertyModelEnumConverter.paymentTypeValues.map[paymentType]),
      "minBathroom": minBathrooms,
      "maxBathroom": maxBathrooms,
      "furnishingType": jsonEncode(PropertyModelEnumConverter.furnishedStatusValues.map[furnishingType]),
      "amenityIds": amenityIds == null || amenityIds.isEmpty ? null : jsonEncode(amenityIds),
      "tour": tour,
      "keywordArray": keywordArray == null || keywordArray.isEmpty ? null : jsonEncode(keywordArray),
      "limit": limit,
      "offset": offset,
      "locationArray": locationArray == null || locationArray.isEmpty
          ? null
          : jsonEncode(locationArray.map((e) => e.toJson()).toList()),
      "planType": PropertyModelEnumConverter.planTypeValues.map[planType],
      "sort": sort
    };
    try {
      queryParameters.removeWhere((key, value) => value == null || value == "null");
      final response = await dio.get(url, queryParameters: queryParameters);
      var jsonDataObject = jsonDecode(response.data);
      PropertyListingListModel filterResult = PropertyListingListModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      print(e);
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    }
    // catch (e) {
    //   return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    // }
  }

  @override
  Future<Either<Failure, PropertyModel>> getPropertyById(String propertyId) async {
    String url = "propertyById";

    try {
      final response = await dio.get(url, queryParameters: {"property_id": propertyId});

      var jsonDataObject = jsonDecode(response.data);

      developer.log('\x1B[32m${jsonDataObject["property_details"]["features"]}\x1B[0m');
      PropertyModel propertyResult = PropertyModel.fromJson(jsonDataObject["property_details"]);
      print(propertyResult.propertyImages);
      return Right(propertyResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, PropertyLocationDetailModel>> getPropertyLocationDetails(LatLng position) async {
    String url = "closestLocationList";
    try {
      final response = await dio.get(url, queryParameters: {"lat": position.latitude, "lng": position.longitude});
      var jsonDataObject = jsonDecode(response.data);
      PropertyLocationDetailModel locationResult = PropertyLocationDetailModel.fromJson(jsonDataObject);
      return Right(locationResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, PropertyListingListModel>> getCommunityFeaturedProperties(
      {required Map<String, dynamic> params}) async {
    String url = "search";
    try {
      final response = await dio.get(url, queryParameters: params);

      var jsonDataObject = jsonDecode(response.data);
      PropertyListingListModel filterResult = PropertyListingListModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      print("#log : EROOR : ${e.message}");
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      print("#log : EROOR : ${e}");
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, BookedPropertiesResponseModel>> getBookedProperties() async {
    String url = "myproperties/booked";
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};
      final response = await dio.get(url, options: Options(headers: headers), queryParameters: {});

      var jsonDataObject = jsonDecode(response.data);
      print('#res : $jsonDataObject');
      BookedPropertiesResponseModel filterResult = BookedPropertiesResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      print("#log : BookedPropertiesResponseModel EROOR : ${e.message}");
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      print("#log : BookedPropertiesResponseModel EROOR : ${e}");
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, BookedPropertiesResponseModel>> getInProcessProperties() async {
    String url = "myproperties/inProcess";
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};
      final response = await dio.get(url, options: Options(headers: headers), queryParameters: {});

      var jsonDataObject = jsonDecode(response.data);
      BookedPropertiesResponseModel filterResult = BookedPropertiesResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      print("#log : InProcessPropertiesResponseModel EROOR : ${e.message}");
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      print("#log : InProcessPropertiesResponseModel EROOR : ${e}");
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, BookedPropertiesResponseModel>> getSavedProperties() async {
    String url = "myproperties/saved";
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final headers = {"Authorization": await user?.getIdToken()};
      final response = await dio.get(url, options: Options(headers: headers), queryParameters: {});

      var jsonDataObject = jsonDecode(response.data);
      BookedPropertiesResponseModel filterResult = BookedPropertiesResponseModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      print("#log : SavedPropertiesResponseModel EROOR : ${e.message}");
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      print("#log : SavedPropertiesResponseModel EROOR : ${e}");
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, bool>> bookmarkProperty(String propertyId) async {
    String url = "myproperties/saveOrDeleteBookmark";
    try {
      await dio.post(url, data: {"property_id": propertyId});
      return Right(true);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, bool>> checkPropertyBookmarkStatus(String propertyId) async {
    String url = "isSavedProperty";
    try {
      final response = await dio.get(url, queryParameters: {"property_id": propertyId});
      var jsonDataObject = jsonDecode(response.data);
      bool isSaved = jsonDataObject['isSaved'] ?? false;
      return Right(isSaved);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }
}
