import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failure.dart';
import '../../models/facility_management_model/property_location_model.dart';
import '../../models/home_page_model/suggest_places_model.dart';

abstract class IHttpHelper {
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

  // ? Authentication Section

  /// Signup using email and password using firebase.
  /// handles all the [FirebaseAuthException]
  // TODO: failure message localization
  Future<Either<Failure, UserCredential>> emailSignup({required String email, required String password});

  /// Add personal details of user after signup
  Future<Either<Failure, bool>> postUserPersonalDetails({
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
    required String email,
  });

  /// Login using email and password
  /// handles all the [FirebaseAuthException]
  // TODO: failure message localization
  Future<Either<Failure, UserCredential>> emailLogin({required String email, required String password});

  /// Login using phone number and otp
  Future<Either<Failure, UserCredential>> phoneLogin({required String phoneNumber});

  // ? Home Section
  // Future<HomePageModel> getHomeData();

  Future<SuggestPlacesModel> getSuggestPlaces(
    String? searchParam,
  );

  // Future<AmenitiesModel> getAmenities();

  // Future<PropertyTypesModel> getPropertyTypes();

  // ? Agency Form

  Future<Either<Failure, PropertyLocationListModel>> getPropertyLocation();

  Future<Either<Failure, bool>> addCompany(
      {required String companyName,
      required String typeOfOrganization,
      required int numberOfProperties,
      required List<Map<dynamic, dynamic>> locationProperties,
      required String type,
      required List<String> amc});
}
