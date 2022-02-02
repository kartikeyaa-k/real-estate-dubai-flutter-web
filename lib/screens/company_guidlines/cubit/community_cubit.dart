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

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityGuidelineService _communityGuidelineService;

  CommunityCubit({required CommunityGuidelineService communityGuidelineService})
      : _communityGuidelineService = communityGuidelineService,
        super(CommunityInit());

  Future<void> getCommunityGuidelines() async {
    emit(LCommunityGuidelines());

    final responseEither = await _communityGuidelineService.getCommunityGuidelines();

    responseEither.fold(
      (failure) {
        print('#log : FCommunityGuidelines =>');
        print(failure.errorMessage);
        emit(FCommunityGuidelines(failure: failure));
      },
      (data) {
        // print('#log : SCommunityGuidelines => ${data.result}');
        emit(SCommunityGuidelines(result: data.result ?? []));
      },
    );
  }

  Future<void> getCommunityDetails({required int community_id}) async {
    emit(LCommunityDetails());

    CommunityDetailRequestParams requestParams = CommunityDetailRequestParams(community_id: community_id);

    final response = await _communityGuidelineService.getCommunityDetails(requestParams);

    response.fold(
      (failure) {
        print('#log : FCommunityDetails =>');
        print(failure.errorMessage);
        emit(FCommunityDetails(failure: failure));
      },
      (data) {
        // print('#log : SCommunityDetails => ${data.result.emirateName}');
        emit(SCommunityDetails(result: data.result));
      },
    );
  }
}
