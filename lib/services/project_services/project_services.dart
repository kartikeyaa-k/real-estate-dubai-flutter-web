import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/error/failure.dart';
import '../../models/home_page_model/suggest_places_model.dart';
import '../../models/project_model/project_model.dart';
import '../../screens/project_listing/constants/project_list_contants.dart';

abstract class ProjectServices {
  Future<Either<Failure, ProjectListModel>> searchProjects({
    int? limit,
    int? offset,
    List<int>? amenityIds,
    List<String>? keywordArray,
    List<PlacesResultModel>? locationArray,
    int? minPrice,
    int? maxPrice,
    int? minYear,
    String? sort,
  });

  Future<Either<Failure, ProjectModel>> getProjectById({required String projectId});
}

class ProjectServicesImpl extends ProjectServices {
  final Dio dio;

  ProjectServicesImpl({required this.dio});

  @override
  Future<Either<Failure, ProjectListModel>> searchProjects({
    int? limit = kProjPerPage,
    int? offset = 0,
    List<int>? amenityIds,
    List<String>? keywordArray,
    List<PlacesResultModel>? locationArray,
    int? minPrice,
    int? maxPrice,
    int? minYear,
    String? sort,
  }) async {
    String url = "ws-projects/searchProjects";
    Map<String, dynamic>? queryParameters = {
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "amenityIds": jsonEncode(amenityIds),
      "keywordArray": jsonEncode(keywordArray),
      "locationArray": locationArray == null || locationArray.isEmpty
          ? null
          : jsonEncode(locationArray.map((e) => e.toJson()).toList()),
      "minYear": minYear,
      "limit": limit,
      "offset": offset,
      "sort": sort,
    };
    try {
      queryParameters.removeWhere((key, value) => value == null || value == "null");
      final response = await dio.get(url, queryParameters: queryParameters);
      var jsonDataObject = jsonDecode(response.data);
      ProjectListModel filterResult = ProjectListModel.fromJson(jsonDataObject);
      return Right(filterResult);
    } on DioError catch (e) {
      print(e);
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }

  @override
  Future<Either<Failure, ProjectModel>> getProjectById({required String projectId}) async {
    String url = "ws-projects/getProjectById";
    try {
      print('#log =>> network call');
      final response = await dio.get(url, queryParameters: {"project_id": projectId});

      var jsonDataObject = jsonDecode(response.data);
      ProjectModel projectResult = ProjectModel.fromJson(jsonDataObject["project_details"]);
      return Right(projectResult);
    } on DioError catch (e) {
      return Left(Failure(errorMessage: e.message, errorUrl: url));
    } catch (e) {
      return Left(Failure(errorMessage: "Ops! something went wrong", errorUrl: url));
    }
  }
}
