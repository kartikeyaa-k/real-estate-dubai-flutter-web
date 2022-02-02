/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/request_models/community_buildings_request_model.dart';
import 'package:real_estate_portal/models/request_models/community_detail_request_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_building_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_detail_model.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/emirates_model.dart';
import 'package:real_estate_portal/services/community_guidelines_services/community_guidelines_services.dart';

part 'community_building_state.dart';

class CommunityBuildingCubit extends Cubit<CommunityBuildingState> {
  CommunityGuidelineService _communityGuidelineService;

  CommunityBuildingCubit({required CommunityGuidelineService communityGuidelineService})
      : _communityGuidelineService = communityGuidelineService,
        super(CommunityBuildingInit());

  Future<void> getCommunityBuildings({required int community_id, int limit = 10, int offset = 0}) async {
    emit(LCommunityBuildings());
    CommunityBuildingRequestParams requestParams =
        CommunityBuildingRequestParams(community_id: community_id, limit: limit, offset: offset);
    final response = await _communityGuidelineService.getCommunityBuilding(requestParams);

    response.fold(
      (failure) {
        print('#log : FCommunityBuildings =>');
        print(failure.errorMessage);
        emit(FCommunityBuildings(failure: failure));
      },
      (data) {
        // print('#log : SCommunityBuildings total  => ${data.total}');
        emit(SCommunityBuildings(result: data.result ?? [], total: data.total));
      },
    );
  }
}
