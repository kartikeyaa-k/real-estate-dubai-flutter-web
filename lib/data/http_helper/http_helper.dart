import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failure.dart';
import '../../models/facility_management_model/property_location_model.dart';
import '../../models/home_page_model/suggest_places_model.dart';
import 'Ihttp_helper.dart';

class HttpHelper implements IHttpHelper {
  final Dio dio;
  var cookieJar = CookieJar();

  HttpHelper({required this.dio}) {
    // dio.interceptors.add(
    //   LogInterceptor(
    //     request: true,
    //     requestBody: true,
    //     responseBody: true,
    //   ),
    // );
    // dio.interceptors.add(
    //   CookieManager(cookieJar),
    // );
  }

  // @override
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
  //   try {
  //     final response = await dio.get(
  //       'search?minBedroom=$minBedrooms&maxBedroom=$maxBedrooms&minPrice=$minPrice&maxPrice=$maxPrice&minArea=$minArea&maxArea=$maxArea&paymentType=$pay&minBathroom=$minBathrooms&maxBathroom=$maxBathrooms&keywordArray=["$keywords"]',
  //     );
  //     if (response.statusCode == 200) {
  //       var jsonDataObject = jsonDecode(response.data);
  //       FilterResults mFilterResults = FilterResults.fromJson(jsonDataObject);
  //       return mFilterResults;
  //     } else {
  //       throw Exception();
  //     }
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  // @override
  // Future<HomePageModel> getHomeData() async {
  //   try {
  //     final response = await dio.get('home?limit=10&offset=0');
  //     if (response.statusCode == 200) {
  //       var jsonDataObject = jsonDecode(response.data);
  //       HomePageModel mHomePageModel = HomePageModel.fromJson(jsonDataObject);
  //       return mHomePageModel;
  //     } else {
  //       throw Exception();
  //     }
  //   } on DioError catch (e) {
  //     throw Exception();
  //   }
  // }

  @override
  Future<SuggestPlacesModel> getSuggestPlaces(
    String? searchParam,
  ) async {
    try {
      final response = await dio.get(
        'suggest-places?search_param=$searchParam',
      );
      if (response.statusCode == 200) {
        var jsonDataObject = jsonDecode(response.data);
        SuggestPlacesModel mSuggestPlacesResults = SuggestPlacesModel.fromJson(jsonDataObject);
        return mSuggestPlacesResults;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  // @override
  // Future<AmenitiesModel> getAmenities() async {
  //   try {
  //     final response = await dio.get('amenities');
  //     if (response.statusCode == 200) {
  //       var jsonDataObject = jsonDecode(response.data);
  //       print(jsonDataObject);

  //       AmenitiesModel mAmenitiesResults = AmenitiesModel.fromJson(jsonDataObject);
  //       return mAmenitiesResults;
  //     } else {
  //       throw Exception();
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception();
  //   }
  // }

  // @override
  // Future<PropertyTypesModel> getPropertyTypes() async {
  //   try {
  //     final response = await dio.get('property-types');
  //     if (response.statusCode == 200) {
  //       var jsonDataObject = jsonDecode(response.data);
  //       PropertyTypesModel mPropertyTypesResults = PropertyTypesModel.fromJson(jsonDataObject);
  //       return mPropertyTypesResults;
  //     } else {
  //       throw Exception();
  //     }
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  @override
  Future<Either<Failure, UserCredential>> emailSignup({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use')
        return Left(Failure(errorMessage: "The email is already in use.", errorUrl: "firebase email signup"));

      if (e.code == 'invalid-email')
        return Left(Failure(errorMessage: "The email entered is invalid.", errorUrl: "firebase email signup"));

      if (e.code == 'operation-not-allowed')
        return Left(Failure(errorMessage: "The email entered is invalid.", errorUrl: "firebase email signup"));

      if (e.code == 'weak-password')
        return Left(
            Failure(errorMessage: "email/password accounts are not enabled.", errorUrl: "firebase email signup"));

      if (e.code == 'email-already-in-use')
        return Left(
            Failure(errorMessage: "The account already exists for that email.", errorUrl: "firebase email signup"));

      return Left(Failure(errorMessage: "Server failure", errorUrl: "firebase email signup"));
    } catch (e) {
      return Left(
        Failure(
          errorMessage: "Ops! something went wrong. Please retry after few minutes.",
          errorUrl: "firebase email signup",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> postUserPersonalDetails({
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
    required String email,
  }) async {
    String url = "addUser";
    try {
      var data = {
        "first_name": firstName,
        "surname": lastName,
        "email": email,
        "gender": gender,
        "mobile": phone.replaceAll(" ", "")
      };
      var response = await dio.post(url, data: data);

      if (response.statusCode == 200) return Right(true);

      return Left(Failure(errorUrl: url, errorMessage: "failed with status code ${response.statusCode}"));
    } on DioError catch (e) {
      return Left(Failure(errorUrl: e.requestOptions.path, errorMessage: jsonDecode(e.message)['message']['message']));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> emailLogin({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email')
        return Left(Failure(errorMessage: "The email provided is not registered.", errorUrl: "firebase email login"));

      if (e.code == 'user-disabled')
        return Left(Failure(
            errorMessage: "The user corresponding to the given email has been disabled.",
            errorUrl: "firebase email login"));

      if (e.code == 'user-not-found')
        return Left(Failure(errorMessage: "No user found for that email.", errorUrl: "firebase email login"));

      if (e.code == 'wrong-password')
        return Left(Failure(errorMessage: "Wrong password provided for that user.", errorUrl: "firebase email login"));

      return Left(Failure(errorMessage: "Server failure", errorUrl: "firebase email login"));
    } catch (e) {
      return Left(
        Failure(
          errorMessage: "Ops! something went wrong. Please retry after few minutes.",
          errorUrl: "firebase email login",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserCredential>> phoneLogin({required String phoneNumber}) {
    // TODO: implement phoneLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PropertyLocationListModel>> getPropertyLocation() async {
    String url = "/ws/property-owner/listLocation";
    try {
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        return Right(PropertyLocationListModel.fromJson(json.decode(response.data)));
      }

      return Left(Failure(errorUrl: url, errorMessage: "failed with status code ${response.statusCode}"));
    } on DioError catch (e) {
      print('#log : error : ${e.message}');
      print(e);
      return Left(Failure(errorUrl: e.requestOptions.path, errorMessage: e.message));
    } catch (e, stk) {
      print('#log : error : ${e.toString()}');
      print('#log : error : ${stk.toString()}');
      return Left(Failure(errorMessage: "Oops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, bool>> addCompany({
    required String companyName,
    required String typeOfOrganization,
    required int numberOfProperties,
    required List locationProperties,
    required String type,
    required List<String> amc,
  }) async {
    String url = "addCompany";
    try {
      var data = {
        "company_name": companyName,
        "type_of_organization": typeOfOrganization,
        "number_of_properties": numberOfProperties,
        "location_of_properties": locationProperties,
        "type": type,
        "annual_maintenance_contract": amc
      };
      var response = await dio.post(url, data: data);

      if (response.statusCode == 200) return Right(true);

      return Left(Failure(errorUrl: url, errorMessage: "failed with status code ${response.statusCode}"));
    } on DioError catch (e) {
      return Left(Failure(errorUrl: e.requestOptions.path, errorMessage: e.message));
    }
  }
}
