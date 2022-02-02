part of 'feautred_property_cubit.dart';

class FeaturedPropertyState extends Equatable {
  const FeaturedPropertyState();

  @override
  List<Object> get props => [];
}

class FeaturedPropertyInit extends FeaturedPropertyState {
  const FeaturedPropertyInit();
}

// GET community building
//Loading
class LFeaturedProperties extends FeaturedPropertyState {
  const LFeaturedProperties();
}

//Failed
class FFeaturedProperties extends FeaturedPropertyState {
  final Failure failure;
  const FFeaturedProperties({required this.failure});
}

//Success
class SFeaturedProperties extends FeaturedPropertyState {
  final PropertyListingListModel propertyListingListModel;
  const SFeaturedProperties({required this.propertyListingListModel});
}
