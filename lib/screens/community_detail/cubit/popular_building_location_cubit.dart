/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/community_buildings_request_model.dart';
import 'package:real_estate_portal/models/request_models/community_detail_request_model.dart';
import 'package:real_estate_portal/models/request_models/popular_building_location_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_building_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_detail_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/emirates_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/popular_building_location_response_model.dart';
import 'package:real_estate_portal/services/community_guidelines_services/community_guidelines_services.dart';

part 'popular_building_location_state.dart';

class PopularBuildingLocationCubit extends Cubit<PopularBuildingLocationState> {
  CommunityGuidelineService _communityGuidelineService;

  PopularBuildingLocationCubit({required CommunityGuidelineService communityGuidelineService})
      : _communityGuidelineService = communityGuidelineService,
        super(PopularBuildingLocationInit());

  Future<void> getPopularBuildingLocation({required int community_id}) async {
    emit(LPopularBuildingLocations());
    PopularBuildingLocationRequestParams requestParams = PopularBuildingLocationRequestParams(community_id: community_id);
    final response = await _communityGuidelineService.getPopularBuildingLocation(requestParams);

    response.fold(
      (failure) {
        print('#log : FPopularBuildingLocations =>');
        print(failure.errorMessage);
        emit(FPopularBuildingLocations(failure: failure));
      },
      (data) {
        emit(SPopularBuildingLocations(result: data));
      },
    );
  }
}
