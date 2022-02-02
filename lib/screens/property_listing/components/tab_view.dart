import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:formz/formz.dart';
import 'package:pagination_indicator/pagination_indicator.dart';
import 'package:real_estate_portal/screens/property_listing/constants/property_listing_const.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/footer.dart';
import '../../../components/listing_cards/featured_card.dart';
import '../../../components/listing_cards/mobile_card.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/home_page_model/property_types_model.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../routes/routes.dart';
import '../cubit/property_listing_cubit.dart';
import 'property_filter.dart';

class TabView extends StatelessWidget {
  TabView({
    Key? key,
    this.minBedrooms,
    this.maxBedrooms,
    this.propertySubTypeId,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.paymentType,
    this.keywords,
    this.minBathrooms,
    this.maxBathrooms,
    this.furnishingType,
    this.amenityIds,
    this.tour,
    this.keywordArray,
    this.limit,
    this.offset,
    this.locationArray,
    this.planType,
    required this.propertyType,
  }) : super(key: key);

  final int? minBedrooms;
  final int? maxBedrooms;
  final int? propertySubTypeId;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final String? paymentType;
  final String? keywords;
  final int? minBathrooms;
  final int? maxBathrooms;
  final String? furnishingType;
  final List<String>? amenityIds;
  final String? tour;
  final List<String>? keywordArray;
  final int? limit;
  final int? offset;
  final List<PropertyTypeModel>? locationArray;
  final String? planType;
  final PropertyType propertyType;

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: _toolBarSwitchCondition
                ? EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset)
                : EdgeInsets.zero,
            child: BlocBuilder<PropertyListingCubit, PropertyListingState>(
              builder: (context, state) {
                final List<PropertyModel> list =
                    propertyType == PropertyType.RESIDENTIAL ? state.residencialProperties : state.commercialProperties;

                return Row(
                  crossAxisAlignment: state.status.isSubmissionInProgress || list.isEmpty
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isDesktop(context)) ...[
                      Align(alignment: Alignment.topLeft, child: PropertyFilter(cubit: context.read())),
                      SizedBox(width: 30),
                    ],
                    BlocBuilder<PropertyListingCubit, PropertyListingState>(
                      builder: (context, state) {
                        if (state.status.isSubmissionInProgress)
                          return Expanded(child: Center(child: SpinKitThreeBounce(color: kSupportBlue)));

                        if (list.isEmpty)
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Ops! it seems we don't have property for these categories",
                                      style: TextStyles.h4,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: Insets.med),
                                    PrimaryOutlinedButton(
                                      width: 200,
                                      onTap: () {
                                        context.vRouter.to(context.vRouter.path, isReplacement: true);
                                        // context.read<PropertyListingCubit>().clearAllFilters();
                                      },
                                      text: "clear filters",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );

                        Widget _mobileList = Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsetsDirectional.only(bottom: 2),
                              child: MobileCard(
                                name: list[index].propertyDetails.propertyName.en,
                                address: list[index].areaCommunityDetails.communityName.en,
                                bedrooms: list[index].propertyDetails.bedroomsCount,
                                bathroom: list[index].propertyDetails.bathroomsCount,
                                image: list[index].propertyDetails.coverImage,
                                price: list[index].propertyDetails.propertySellingPrice ??
                                    list[index].propertyRentOrBuyPlans.first.price,
                                tenure: list[index].propertyRentOrBuyPlans.first.planName.en,
                                sqft: list[index].propertyDetails.sizeInSqFeets,
                                onTap: () {
                                  context.vRouter.to(PropertyDetailScreenPath,
                                      queryParameters: {"id": list[index].propertyDetails.id.toString()});
                                },
                              ),
                            ),
                          ),
                        );

                        Widget _desktopList = Flexible(
                          child: GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: Responsive.isMobile(context) ? 382 : 400,
                              mainAxisExtent: Responsive.isMobile(context) ? 445 : 459,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: Times.medium,
                                columnCount: list.length,
                                child: FeaturedCard(
                                  title: list[index].propertyDetails.propertyName.en,
                                  address: list[index].areaCommunityDetails.communityName.en,
                                  price: list[index].propertyRentOrBuyPlans.isEmpty ||
                                          list[index].propertyRentOrBuyPlans.first.price == 0
                                      ? null
                                      : list[index].propertyRentOrBuyPlans.first.price,
                                  tenure: list[index].propertyRentOrBuyPlans.first.planName.en,
                                  area: list[index].propertyDetails.sizeInSqFeets,
                                  bedroomCount: list[index].propertyDetails.bedroomsCount,
                                  bathroomCount: list[index].propertyDetails.bathroomsCount,
                                  image: list[index].propertyDetails.coverImage,
                                  onViewDetails: () {
                                    context.vRouter.to(PropertyDetailScreenPath,
                                        queryParameters: {"id": list[index].propertyDetails.id.toString()});
                                  },
                                ),
                              );
                            },
                          ),
                        );

                        if (_toolBarSwitchCondition)
                          return _desktopList;
                        else
                          return _mobileList;
                      },
                    )
                  ],
                );
              },
            ),
          ),
          Center(
            child: BlocBuilder<PropertyListingCubit, PropertyListingState>(
              builder: (context, state) {
                if (state.status.isSubmissionInProgress) {
                  return Container();
                }

                int pageCount = ((context.vRouter.queryParameters["type"] == "c"
                            ? state.commercialProperties.length
                            : state.residencialProperties.length) /
                        kPropertyPerPage)
                    .ceil();
                int selectedPage = int.tryParse(context.vRouter.queryParameters[kPageNumberKey] ?? "1") ?? 1;
                return Row(
                  children: [
                    Spacer(),
                    if (pageCount > 1 && selectedPage != 1)
                      PrimaryButton(
                        onTap: () {
                          Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                          int currentPage = int.tryParse(updateQuery[kPageNumberKey] ?? "2") ?? 2;
                          int previousPage = currentPage - 1;
                          if (updateQuery.containsKey(kPageNumberKey)) {
                            updateQuery.update(kPageNumberKey, (_) => previousPage.toString());
                          } else {
                            updateQuery[kPageNumberKey] = previousPage.toString();
                          }
                          // replace the route
                          context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                        },
                        text: "Previous",
                        width: 100,
                      ),

                    // pages
                    SizedBox(width: 8),
                    PaginationIndicator(
                      pageCount: pageCount,
                      initialValue: selectedPage < 1 ? 1 : selectedPage,
                      visiblePageCount: 10,
                      onPageChanged: (index) {
                        Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                        if (updateQuery.containsKey(kPageNumberKey)) {
                          updateQuery.update(kPageNumberKey, (_) => "$index");
                        } else {
                          updateQuery[kPageNumberKey] = index.toString();
                        }
                        // replace the route
                        context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                      },
                    ),

                    SizedBox(width: 8),

                    if (state.totalPropertyCount > 10 && selectedPage != pageCount)
                      PrimaryButton(
                        onTap: () {
                          Map<String, String> updateQuery = {...context.vRouter.queryParameters};
                          int currentPage = int.tryParse(updateQuery[kPageNumberKey] ?? "1") ?? 1;
                          int nextPage = currentPage + 1;
                          if (updateQuery.containsKey(kPageNumberKey)) {
                            updateQuery.update(kPageNumberKey, (_) => ("$nextPage").toString());
                          } else {
                            updateQuery[kPageNumberKey] = nextPage.toString();
                          }
                          // replace the route
                          context.vRouter.to(context.vRouter.path, isReplacement: true, queryParameters: updateQuery);
                        },
                        text: "Next",
                        width: 100,
                      ),
                    Spacer()
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          if (Responsive.isDesktop(context)) Footer()
        ],
      ),
    );
  }
}
