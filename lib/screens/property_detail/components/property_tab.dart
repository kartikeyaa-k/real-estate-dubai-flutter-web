import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/carousel/carousel.dart';
import '../../../components/company_banner.dart';
import '../../../components/footer.dart';
import '../../../components/listing_cards/latest_card.dart';
import '../../../components/property_price_schedule_banner.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../injection_container.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../models/response_models/book_status_response_models/book_status_response_model.dart';
import '../../project_detail/cubit/book_status_cubit.dart';
import '../cubit/property_cubit.dart';
import '../cubit/verification_cubit.dart';
import 'primary_detail.dart';
import 'reviews.dart';
import 'secondary_detail_card.dart';
import 'verification_banner.dart';

/// contains everything that is shown on property tab
class PropertyTab extends StatefulWidget {
  final String? projectName;
  final String? projectLocation;
  final int? bedroom;
  final int? bathroom;
  final int? sqft;
  final String? floor;
  final String? type;
  final String? desc;
  final double? properyPrice;
  final int id;
  final List<PropertyRentOrBuyPlan>
      propertyRentOrBuyPlans;
  const PropertyTab({
    Key? key,
    this.projectName,
    this.projectLocation,
    this.bedroom,
    this.bathroom,
    this.sqft,
    this.floor,
    this.properyPrice,
    required this.propertyRentOrBuyPlans,
    required this.id,
    this.type,
    this.desc,
  }) : super(key: key);

  @override
  _PropertyTabState createState() =>
      _PropertyTabState();
}

class _PropertyTabState
    extends State<PropertyTab> {
  // late BookStatusCubit cubit;
  late VerificationCubit _verificationCubit;

  @override
  void initState() {
    super.initState();

    _verificationCubit = sl<VerificationCubit>();

    loadStatus();
  }

  loadStatus() {
    // cubit.getBookStatus(widget.id.toString());
    _verificationCubit
        .getStatus(widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget _vSpace = Responsive.isDesktop(context)
        ? SizedBox(height: Insets.xxl)
        : SizedBox(height: Insets.med);
    double _offset = Responsive.isDesktop(context)
        ? Insets.offset
        : 0;

    Widget verificationBanner = BlocBuilder<
            VerificationCubit, VerificationState>(
        bloc: _verificationCubit,
        builder: (context, state) {
          if (state is LVerification) {
            return _BookStatusLoading();
          } else if (state is FVerification) {
            print(
                '#log : = > FVerification : ${state.failure.errorMessage}');
          } else if (state is SVerification) {
            if (state.result.verificationStatus ==
                '') {
              return Container();
            }
            return Column(
              children: [
                VerificationStatusBanner(
                    propertyId: widget.id,
                    verificationStatusResponseModel:
                        state.result),
                SizedBox(height: Insets.xxl)
              ],
            );
          }

          return Container();
        });

    Widget propertyPriceScheduleBanner =
        BlocBuilder<BookStatusCubit,
            BookStatusState>(
      bloc: context.read(),
      builder: (context, state) {
        if (state is LBookStatus) {
          return _BookStatusLoading();
        } else if (state is SBookStatus) {
          print(
              "#log : SBookStatus property tab => ${state.result.status}");
          return BlocBuilder<PropertyDetailCubit,
                  PropertyDetailState>(
              builder: (_, st) {
            return PropertyPriceScheduleBanner(
                propertyRentOrBuyPlans:
                    widget.propertyRentOrBuyPlans,
                propertyPrice: state
                    .result.actual_price
                    .toString(),
                propertyId: widget.id,
                bookStatusResponseModel:
                    state.result);
          });
        }

        return BlocBuilder<PropertyDetailCubit,
            PropertyDetailState>(
          builder: (_, st) {
            return PropertyPriceScheduleBanner(
                propertyRentOrBuyPlans:
                    widget.propertyRentOrBuyPlans,
                propertyPrice: widget.properyPrice !=
                        null
                    ? widget.properyPrice!
                        .toString()
                    : st
                            .propertyData
                            .propertyRentOrBuyPlans
                            .first
                            .price
                            .toString() +
                        "/" +
                        st
                            .propertyData
                            .propertyRentOrBuyPlans
                            .first
                            .planName
                            .en,
                propertyId: widget.id,
                bookStatusResponseModel:
                    BookStatusResponseModel(
                        status: ""));
          },
        );
      },
    );

    Widget _sideCards = BlocBuilder<
        PropertyDetailCubit, PropertyDetailState>(
      builder: (context, state) {
        final _agencyDetails =
            state.propertyData.agencyDetails;

        return Column(
          children: [
            // PropertyCostCard(price: state.propertyData.propertyDetails.propertySellingPrice?.toInt().toString() ?? "-"),
            _vSpace,
            CompanyBanner(
              agencyName:
                  _agencyDetails.agencyName,
              agentName: _agencyDetails.agentName,
              coverImage:
                  _agencyDetails.coverImage,
              agentPhone:
                  _agencyDetails.agentPhone,
            ),
          ],
        );
      },
    );

    Widget _propertyDetailSecondaryDetailCard =
        BlocBuilder<PropertyDetailCubit,
            PropertyDetailState>(
      builder: (context, state) {
        return Column(
          children: [
            PropertyDetailSecondaryDetailCard(
              bathroom: state.propertyData
                  .propertyDetails.bathroomsCount,
              bedroom: state.propertyData
                  .propertyDetails.bedroomsCount,
              sqft: state.propertyData
                  .propertyDetails.sizeInSqFeets
                  .toInt(),
              floor:
                  "${state.propertyData.floorNumber} Floors",
              type: state
                  .propertyData
                  .propertyDetails
                  .subType
                  .name
                  .en,
              desc: state
                  .propertyData
                  .propertyDetails
                  .propertyDescription
                  .en,
              amenities:
                  state.propertyData.amenities,
              additionalFeatures:
                  state.propertyData.features,
              position: state.propertyData
                  .propertyDetails.location,
              locationDetails:
                  state.propertyLocationDetail,
            ),
            _vSpace,

            // Detail card
            Container(
              padding: EdgeInsets.all(Insets.xl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    Responsive.isDesktop(context)
                        ? Corners.lgBorder
                        : null,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _singleDetailForDetailCard(
                            "Reference:",
                            state
                                .propertyData
                                .propertyDetails
                                .referenceNumber),
                        SizedBox(
                            height: Insets.xl),
                        _singleDetailForDetailCard(
                            "Permit number:",
                            state
                                .propertyData
                                .propertyDetails
                                .govtPermitNumber),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _singleDetailForDetailCard(
                          "Listed:",
                          DateFormat("dd MMM y")
                              .format(state
                                  .propertyData
                                  .datePublished!),
                        ),
                        // _singleDetailForDetailCard(
                        //   "Broker ORN:",
                        //   "123241422",
                        // ),
                        // SizedBox(height: Insets.xl),
                        // _singleDetailForDetailCard(
                        //   "Agent BRN:",
                        //   "123241422",
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    Widget _secondaryAndSideCard = Flex(
      direction: Responsive.isDesktop(context)
          ? Axis.horizontal
          : Axis.vertical,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Responsive.isDesktop(context)
            ? Expanded(
                flex: 2,
                child:
                    _propertyDetailSecondaryDetailCard,
              )
            : _propertyDetailSecondaryDetailCard,
        Responsive.isDesktop(context)
            ? SizedBox(
                width: Insets.xl,
              )
            : _vSpace,
        Responsive.isDesktop(context)
            ? SizedBox(
                width: Insets.xl,
              )
            : _vSpace,

        Responsive.isDesktop(context)
            ? Expanded(
                child: Column(
                children: [
                  verificationBanner,
                  propertyPriceScheduleBanner,
                  SizedBox(
                    height: Insets.xs,
                  ),
                  _sideCards,
                ],
              ))
            : Column(
                children: [
                  verificationBanner,
                  SizedBox(
                    height: Insets.med,
                  ),
                  propertyPriceScheduleBanner,
                  SizedBox(
                    height: Insets.xs,
                  ),
                  _sideCards,
                ],
              ),
        // Responsive.isDesktop(context)
        //     ? Expanded(
        //         child: Column(
        //         children: [
        //           Responsive.isDesktop(context) ? Expanded(child: propertyPriceScheduleBanner) : propertyPriceScheduleBanner,
        //           _sideCards,
        //         ],
        //       ))
        //     : _sideCards,
      ],
    );

    Widget _relatedPropertyList = Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(
              vertical: Insets.xl)
          : EdgeInsets.all(Insets.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "More Related Properties",
                  style: TextStyles.h2,
                ),
              ),
              Spacer(),
              if (!Responsive.isMobile(
                  context)) ...[
                InkWell(
                  child: Text(
                    "See All(200)",
                    style: TextStyles.body12
                        .copyWith(
                            color: kSupportBlue),
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 18),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                      Icons
                          .arrow_forward_ios_sharp,
                      size: 18),
                ),
              ] else
                InkWell(
                  child: Text(
                    "See All(200)",
                    style: TextStyles.body12
                        .copyWith(
                            color: kSupportBlue),
                  ),
                ),
            ],
          ),
          SizedBox(height: Insets.lg),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  Padding(
                padding:
                    EdgeInsetsDirectional.only(
                        end: Insets.xl),
                child: LatestCard(),
              ),
            ),
          ),
        ],
      ),
    );

    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _offset),
          child: Column(
            children: [
              BlocBuilder<PropertyDetailCubit,
                  PropertyDetailState>(
                builder: (context, state) {
                  return PropertyDetailPrimaryDetailCard(
                    projectName: state
                        .propertyData
                        .propertyDetails
                        .propertyName
                        .en,
                    location: state
                        .propertyData
                        .areaCommunityDetails
                        .communityName
                        .en,
                    isVerified: state
                        .propertyData
                        .propertyDetails
                        .isVerified,
                    rating:
                        "${state.propertyData.averagePropertyRating}(${state.propertyData.netReviewCount})",
                  );
                },
              ),
              _vSpace,
              _secondaryAndSideCard,
              _vSpace,
              PropertyDetailReviews(),
              _vSpace,
              // _relatedPropertyList,
              // _vSpace,
            ],
          ),
        ),
        if (Responsive.isDesktop(context))
          Footer()
      ],
    );
  }

  Row _singleDetailForDetailCard(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyles.body18
                .copyWith(color: Colors.black),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: TextStyles.body18
                .copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _BookStatusLoading extends StatelessWidget {
  const _BookStatusLoading({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Insets.offset),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                width: double.infinity,
                height: 164,
                color: Colors.white),
            SizedBox(height: 30),
            Container(
                width: double.infinity,
                height: 164,
                color: Colors.white),
            SizedBox(height: 30),
            Container(
                width: double.infinity,
                height: 164,
                color: Colors.white),
          ],
        ),
      ),
    );
  }
}
