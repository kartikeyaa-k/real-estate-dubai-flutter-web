/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/home_page_model/suggest_places_model.dart';
import 'package:real_estate_portal/models/property_details_models/property_model.dart';
import 'package:real_estate_portal/models/request_models/community_buildings_request_model.dart';
import 'package:real_estate_portal/models/request_models/community_detail_request_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_building_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_detail_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/emirates_model.dart';
import 'package:real_estate_portal/services/community_guidelines_services/community_guidelines_services.dart';
import 'package:real_estate_portal/services/property_services/property_services.dart';

part 'featured_property_state.dart';

class FeaturedPropertyCubit extends Cubit<FeaturedPropertyState> {
  PropertyServices _propertyServices;

  FeaturedPropertyCubit({required PropertyServices propertyServices})
      : _propertyServices = propertyServices,
        super(FeaturedPropertyInit());

  Future<void> getFeaturedProperty({int offset = 0, int limit = 10, required int community_id}) async {
    PlacesResultModel locationArray = PlacesResultModel(id: community_id, category: "area_community", name: "");

    List<PlacesResultModel> list = [];
    list.add(locationArray);
    emit(LFeaturedProperties());
    Map<String, dynamic>? queryParameters = {
      "keywordArray": [],
      "offset": offset,
      "limit": limit,
      "locationArray": jsonEncode(list.map((e) => e.toJson()).toList()),
    };

    print('#log : request => ${queryParameters}');
    final response = await _propertyServices.getCommunityFeaturedProperties(params: queryParameters);

    response.fold(
      (failure) {
        print('#log : FFeaturedProperties =>');
        print(failure.errorMessage);
        emit(FFeaturedProperties(failure: failure));
      },
      (data) {
        print('#log : SFeaturedProperties total  => ${data.result.list.length}');
        emit(SFeaturedProperties(propertyListingListModel: data));
      },
    );
  }
}
