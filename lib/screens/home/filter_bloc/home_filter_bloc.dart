import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/home_page_model/property_types_model.dart';
import '../../../models/home_page_model/suggest_places_model.dart';
import '../../../services/home/home_services.dart';

part 'home_filter_event.dart';
part 'home_filter_state.dart';

class HomeFilterBloc extends Bloc<HomeFilterEvent, HomeFilterState> {
  HomeFilterBloc({
    required HomeServices homeServices,
  })  : _homeServices = homeServices,
        super(HomeFilterState()) {
    on<InitHomeFilter>(_mapInitHomeFilterToState);
    on<SearchParamChanged>(_mapSearchParamChangedToState, transformer: debounce(Duration(milliseconds: 350)));
    on<FindPropertyPressed>(_mapFindPropertyPressedToState);
  }

  final HomeServices _homeServices;

  /*--------------------------------------------*/

  EventTransformer<SearchInputChanged> debounce<SearchInputChanged>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  /*--------------------------------------------*/

  _mapInitHomeFilterToState(InitHomeFilter event, Emitter emit) async {
    emit(state.copyWith(isLoadingPropertyTypes: true));
    final propertyEither = await _homeServices.getPropertyTypes();

    propertyEither.fold(
      (failure) => emit(state.copyWith(searchFailureMessage: failure.errorMessage, isLoadingPropertyTypes: false)),
      (propertyTypeList) => emit(state.copyWith(propertyTypeList: propertyTypeList, isLoadingPropertyTypes: false)),
    );
  }

  /*--------------------------------------------*/

  _mapSearchParamChangedToState(SearchParamChanged event, Emitter emit) async {
    emit(state.copyWith(searchStatus: FormzStatus.submissionInProgress));
    final searchEither = await _homeServices.getSuggestPlaces(event.searchParam);

    searchEither.fold(
      (failure) =>
          emit(state.copyWith(searchFailureMessage: failure.errorMessage, searchStatus: FormzStatus.submissionFailure)),
      (suggestions) => emit(state.copyWith(suggestedPlaces: suggestions, searchStatus: FormzStatus.submissionSuccess)),
    );
  }

  /*--------------------------------------------*/

  _mapFindPropertyPressedToState(FindPropertyPressed event, Emitter emit) {}
}
