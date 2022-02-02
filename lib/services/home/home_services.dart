import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/error/failure.dart';
import '../../models/amenity_model.dart';
import '../../models/home_page_model/community_list_model.dart';
import '../../models/home_page_model/feature_list_model.dart';
import '../../models/home_page_model/project_list_model.dart';
import '../../models/home_page_model/property_types_model.dart';
import '../../models/home_page_model/suggest_places_model.dart';

abstract class HomeServices {
  /// List of suggestion for search bar in filter
  Future<Either<Failure, SuggestPlacesModel>> getSuggestPlaces(String? searchParam);

  /// Get property type for dropdown
  Future<Either<Failure, PropertyTypeListModel>> getPropertyTypes();

  /// Get all posible amenities
  Future<Either<Failure, List<AmenityModel>>> getAmenities();

  /// get home page feature propeties
  Future<Either<Failure, FeatureListingModel>> getFeaturedProperties();

  /// get community list
  Future<Either<Failure, CommunityListModel>> getCommunities();

  /// get project list on home page
  Future<Either<Failure, HomeProjectListModel>> getProjectList();
}

class HomeServicesImpl extends HomeServices {
  HomeServicesImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either<Failure, SuggestPlacesModel>> getSuggestPlaces(String? searchParam) async {
    String url = 'suggest-places?search_param=$searchParam';
    try {
      final response = await dio.get('suggest-places?search_param=$searchParam');
      var jsonDataObject = jsonDecode(response.data);
      SuggestPlacesModel mSuggestPlacesResults = SuggestPlacesModel.fromJson(jsonDataObject);
      print(mSuggestPlacesResults);
      return Right(mSuggestPlacesResults);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, PropertyTypeListModel>> getPropertyTypes() async {
    String url = "property-types";
    try {
      final response = await dio.get(url);
      var jsonDataObject = jsonDecode(response.data);
      PropertyTypeListModel mPropertyTypesResults = PropertyTypeListModel.fromJson(jsonDataObject);
      return Right(mPropertyTypesResults);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, FeatureListingModel>> getFeaturedProperties({int limit = 10, int offset = 0}) async {
    String url = "home/recommended";
    final queryParams = {
      "limit": limit,
      "offset": offset,
      "latitude": 25.0783674,
      "longitude": 55.23426,
      "isUserProvidedLocation": 0
    };
    try {
      final response = await dio.get(url, queryParameters: queryParams);
      var jsonDataObject = jsonDecode(response.data);
      print(jsonDataObject);
      FeatureListingModel featureListingModel = FeatureListingModel.fromJson(jsonDataObject);
      return Right(featureListingModel);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      print(e);
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, CommunityListModel>> getCommunities({int limit = 10, int offset = 0}) async {
    String url = "home/communities";
    final queryParams = {"limit": limit, "offset": offset};
    try {
      final response = await dio.get(url, queryParameters: queryParams);
      var jsonDataObject = jsonDecode(response.data);
      print(jsonDataObject);
      CommunityListModel featureListingModel = CommunityListModel.fromJson(jsonDataObject);
      return Right(featureListingModel);
    } on DioError catch (e) {
      print(e);
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      print(e);
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, HomeProjectListModel>> getProjectList({int limit = 10, int offset = 0}) async {
    String url = "home/projects";
    final queryParams = {"limit": limit, "offset": offset};
    try {
      final response = await dio.get(url, queryParameters: queryParams);
      var jsonDataObject = jsonDecode(response.data);
      HomeProjectListModel featureListingModel = HomeProjectListModel.fromJson(jsonDataObject);
      return Right(featureListingModel);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, List<AmenityModel>>> getAmenities() async {
    String url = "amenities";
    try {
      final response = await dio.get(url);
      var jsonDataObject = jsonDecode(response.data);
      List<AmenityModel> amenities =
          List<AmenityModel>.from(jsonDataObject["list"].map((x) => AmenityModel.fromJson(x)));
      return Right(amenities);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! looks like something went wrong", errorUrl: url));
    }
  }
}
