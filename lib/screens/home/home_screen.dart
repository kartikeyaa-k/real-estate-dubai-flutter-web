import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/listing_cards/featured_card.dart';
import '../../components/listing_cards/image_card.dart';
import '../../components/listing_cards/latest_card.dart';
import '../../components/mobile_app_bar.dart';
import '../../components/scaffold/primary_scaffold.dart';
import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../models/home_page_model/community_list_model.dart';
import '../../models/home_page_model/project_list_model.dart';
import '../../models/property_details_models/property_model.dart';
import '../../routes/routes.dart';
import 'components/home_banner.dart';
import 'components/title_row.dart';
import 'cubit/home_cubit.dart';
import 'filter_bloc/home_filter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeCubit = sl<HomeCubit>();

  late ScrollController _featureScrollController;
  late ScrollController _communityScrollController;
  late ScrollController _projectScrollController;

  @override
  void initState() {
    super.initState();
    _homeCubit.initHomeScreen();

    _featureScrollController = ScrollController();
    _communityScrollController = ScrollController();
    _projectScrollController = ScrollController();
  }

  @override
  void dispose() {
    _homeCubit.close();
    _featureScrollController.dispose();
    _communityScrollController.dispose();
    _projectScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeFilterBloc>().add(InitHomeFilter());
  }

  @override
  Widget build(BuildContext context) {
    double padding = Responsive.isDesktop(context) ? 100 : 16;

    List<Widget> _mobileAppBarActions = [
      IconButton(
        onPressed: () {
          context.vRouter.to(MobilePropertyFilterPath);
        },
        icon: Icon(
          Icons.filter_list,
        ),
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _homeCubit),
      ],
      child: Title(
        title: "Property Just For You | Search for your dream property",
        color: Colors.black,
        child: PrimaryScaffold(
          appBar: Responsive.isDesktop(context)
              ? ToolBar()
              : MobileAppBar(
                  actions: _mobileAppBarActions,
                ),
          children: [
            HomeBanner(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  // Section one
                  SizedBox(height: 40),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) => previous.featureList.total != current.featureList.total,
                    builder: (context, state) {
                      return TitleRow(
                        title: "Recommended Properties",
                        count: "${state.featureList.total}",
                        scrollController: _featureScrollController,
                        listItemCount: state.featureList.featuredList.length,
                        onViewAll: () {
                          context.vRouter.to(PropertyListingScreenPath, queryParameters: {"type": "r"});
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) => previous.featureList != current.featureList,
                    builder: (context, state) {
                      if (state.featureStatus.isSubmissionInProgress) return SpinKitThreeBounce(color: kSupportBlue);

                      List<PropertyModel> featuredList = state.featureList.featuredList;
                      return Container(
                        height: Responsive.isDesktop(context) ? 459 : 394,
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          controller: _featureScrollController,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: Responsive.isDesktop(context) ? Insets.xxl : Insets.lg),
                              child: FeaturedCard(
                                address: featuredList[index].areaCommunityDetails.communityName.en,
                                area: featuredList[index].propertyDetails.sizeInSqFeets,
                                title: featuredList[index].propertyDetails.propertyName.en,
                                bathroomCount: featuredList[index].propertyDetails.bathroomsCount,
                                bedroomCount: featuredList[index].propertyDetails.bedroomsCount,
                                image: featuredList[index].propertyDetails.coverImage,
                                price: featuredList[index].propertyRentOrBuyPlans.isEmpty ||
                                        featuredList[index].propertyRentOrBuyPlans.first.price == 0
                                    ? null
                                    : featuredList[index].propertyRentOrBuyPlans.first.price,
                                tenure: featuredList[index].propertyRentOrBuyPlans.first.planName.en,
                                onViewDetails: () {
                                  context.vRouter.to(
                                    PropertyDetailScreenPath,
                                    queryParameters: {"id": featuredList[index].propertyDetails.id.toString()},
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Section 2
                  SizedBox(height: 40),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) => previous.projectListModel.total != current.projectListModel.total,
                    builder: (context, state) {
                      return TitleRow(
                        title: "Latest Projects",
                        count: "${state.projectListModel.total}",
                        listItemCount: state.projectListModel.projectList.length,
                        scrollController: _projectScrollController,
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) => previous.projectListModel != current.projectListModel,
                    builder: (context, state) {
                      if (state.featureStatus.isSubmissionInProgress) return SpinKitThreeBounce(color: kSupportBlue);

                      List<HomeProjectModel> projectList = state.projectListModel.projectList;
                      return Container(
                        height: Responsive.isDesktop(context) ? 413 : 340,
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          controller: _projectScrollController,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: projectList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: Responsive.isDesktop(context) ? Insets.xxl : Insets.lg),
                              child: LatestCard(
                                address: projectList[index].address,
                                imageLink: projectList[index].imageLink,
                                isVerified: projectList[index].isVerified,
                                name: projectList[index].name,
                                pricePerSqFeet: projectList[index].pricePerSqFeet,
                                status: projectList[index].status,
                                totalUnits: projectList[index].totalUnits,
                                onViewDetail: () {
                                  context.vRouter.to(
                                    ProjectDetailScreenPath,
                                    queryParameters: {"id": projectList[index].id.toString()},
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Section 3
                  SizedBox(height: 40),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        previous.communityListModel.total != current.communityListModel.total,
                    builder: (context, state) {
                      return TitleRow(
                        title: "Community",
                        count: "${state.communityListModel.total}",
                        listItemCount: state.communityListModel.communityList.length,
                        scrollController: _communityScrollController,
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) => previous.communityListModel != current.communityListModel,
                    builder: (context, state) {
                      if (state.featureStatus.isSubmissionInProgress) return SpinKitThreeBounce(color: kSupportBlue);

                      List<CommunityModel> community = state.communityListModel.communityList;
                      return Container(
                        height: Responsive.isDesktop(context) ? 221 : 166,
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          controller: _communityScrollController,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: community.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: Responsive.isDesktop(context) ? Insets.xxl : Insets.lg),
                              child: ImageCard(
                                text: community[index].name,
                                imageUrl: community[index].image,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
