/* Written by : Kartikeya
any questions => write file_no = 2, line_no,  followed by question
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_portal/core/error/failure.dart';
import 'package:real_estate_portal/models/project_model/project_model.dart';
import 'package:real_estate_portal/models/property_details_models/property_location_detail_model.dart';
import 'package:real_estate_portal/models/response_models/cover_page_models/cover_page_model.dart';
import 'package:real_estate_portal/services/cover_page_services/cover_page_services.dart';

part 'cover_page_state.dart';

class CoverPageCubit extends Cubit<CoverPageState> {
  CoverPageService _coverPageService;

  CoverPageCubit({required CoverPageService coverPageService})
      : _coverPageService = coverPageService,
        super(CoverPageInit());

  Future<void> getCoverPage() async {
    emit(LCoverPage());

    final coverPageEither = await _coverPageService.getCoverPage();

    coverPageEither.fold(
      (failure) {
        print('#log : FCoverPage =>');
        print(failure.errorMessage);
        emit(FCoverPage(failure: failure));
      },
      (data) {
        if (data.coverProjectDetails == null) {
          emit(FCoverPage(failure: Failure(errorMessage: "Oops! something went wrong", errorUrl: '')));
        } else {
          print('#log : SCoverPage => ${data.success}');
          print('#log : SCoverPage : coverProjectDetails : => ${data.coverProjectDetails.toString()}');
          print('#log : SCoverPage : otherDetails : => ${data.otherDetails?.isEmpty}');

          emit(SCoverPage(coverProjectDetails: data.coverProjectDetails!, otherDetails: data.otherDetails!));
        }
      },
    );
  }

  Future<void> getLocationDetails(LatLng cord) async {
    emit(LLocationDetail());
    final propertyLocationDetailEither = await _coverPageService.getPropertyLocationDetails(cord);

    propertyLocationDetailEither.fold(
      (failure) {
        print('#log : FLocationDetail =>');
        print(failure.errorMessage);
        emit(FLocationDetail(failure: failure));
      },
      (locationData) {
        print('#log : SLocationDetail => ${locationData}');
        emit(SLocationDetail(propertyLocationDetailModel: locationData));
      },
    );
  }
}
