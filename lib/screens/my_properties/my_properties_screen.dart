import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/components/bottom_navbar.dart';

import '../../components/mobile_app_bar.dart';
import '../../components/primary_tab_bar.dart';
import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../models/response_models/my_properties/booked_properties_response_model.dart';
import '../property_listing/components/app_bar_bottom.dart';
import '../property_listing/components/banner_image.dart';
import 'components/my_properties_tab_view.dart';
import 'cubit/my_properties_cubit.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MyPropertiesScreenState createState() =>
      _MyPropertiesScreenState();
}

enum MyPropertiesTabs {
  RentedProperties,
  InProcess,
  SavedProperties,
  // RejectedProperties,
}

class _MyPropertiesScreenState
    extends State<MyPropertiesScreen>
    with TickerProviderStateMixin {
  /// content padding for dektop and tablets for My properties
  late MyPropertiesCubit _propertiesCubit;
  List<BookedPropertiesModel> _bookedProperties =
      [];
  List<BookedPropertiesModel>
      _inProcessProperties = [];
  List<BookedPropertiesModel> _savedProperties =
      [];

  // FIXME: Gridview compress the children, avoid resizing the child
  @override
  void initState() {
    _propertiesCubit = sl<MyPropertiesCubit>();
    super.initState();
    loadMyProperties();
    _tabController =
        TabController(length: 3, vsync: this);
    _tabList = _tabString
        .map((e) => _tabViewChild(e))
        .toList();
  }

  loadMyProperties() {
    _propertiesCubit.getBookedProperties();
    _propertiesCubit.getInProcessProperties();
    _propertiesCubit.getSavedProperties();
  }

  EdgeInsets desktopContentPadding =
      EdgeInsets.symmetric(
    vertical: Insets.xxl / 2,
    horizontal: Insets.offset,
  );

  late TabController _tabController;
  late List<Widget> _tabList;

  final List<String> _tabString =
      MyPropertiesTabs.values.map((e) {
    String name = e
        .toString()
        .substring(e.toString().indexOf(".") + 1);
    return name.replaceAllMapped(
        RegExp(r'([A-Z])'), (m) => ' ${m[1]}');
  }).toList();

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition =
        !Responsive.isMobile(context);

    // App banner with tab bar
    Widget _tabBarWithImageBanner = Stack(
      children: [
        Column(
          children: _toolBarSwitchCondition
              ? [
                  BannerImage(),
                  SizedBox(height: 40)
                ]
              : [],
        ),
        Positioned(
          bottom: 0,
          left: Insets.offset,
          right: Insets.offset,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "My Properties",
                style: TextStyles.h2.copyWith(
                    color: Colors.white),
              ),
              SizedBox(
                  height: _toolBarSwitchCondition
                      ? 30
                      : 18),
              if (_toolBarSwitchCondition) ...[
                PrimaryTabBar(
                  tabController: _tabController,
                  children: _tabList,
                ),
              ],
            ],
          ),
        ),
      ],
    );

    List<Widget> _mobileAppBarActions = [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.search),
      ),
      IconButton(
        onPressed: () {
          // appState.currentAction = PageAction(
          //   state: PageState.addPage,
          //   page: myPropertiesFilterPageConfig,
          // );
        },
        icon: Icon(Icons.filter_list),
      ),
    ];

    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? ToolBar()
          : MobileAppBar(
              actions: _mobileAppBarActions),
      bottomNavigationBar:
          Responsive.isDesktop(context)
              ? null
              : BottomNavBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            if (Responsive.isMobile(context))
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  maxExtent: 62,
                  minExtent: 62,
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor:
                          kSupportBlue,
                      labelColor: Colors.black,
                      unselectedLabelColor:
                          kBlackVariant,
                      labelStyle: TextStyles.h4
                          .copyWith(
                              color:
                                  kBlackVariant),
                      indicatorWeight: 4,
                      tabs: _tabList,
                    ),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                  child: _tabBarWithImageBanner)
          ];
        },
        body: BlocListener<MyPropertiesCubit,
            MyPropertiesState>(
          bloc: _propertiesCubit,
          listener: (_, state) {
            if (state is LBooked) {
            } else if (state is FBooked) {
            } else if (state is SBooked) {
              setState(() {
                _bookedProperties.addAll(
                    state.result.properties ??
                        []);
              });
              // print('len booked properties : ${_bookedProperties.length}');
            } else if (state is LInProcess) {
            } else if (state is FInProcess) {
            } else if (state is SInProcess) {
              setState(() {
                _inProcessProperties.addAll(
                    state.result.properties ??
                        []);
              });
            } else if (state is LSaved) {
            } else if (state is FSaved) {
            } else if (state is SSaved) {
              setState(() {
                _savedProperties.addAll(
                    state.result.properties ??
                        []);
              });
            }
          },
          child: Container(
            padding: Responsive.isMobile(context)
                ? EdgeInsets.only(top: Insets.sm)
                : null,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Rented Properties
                MyPropertiesTabView(
                  key: ValueKey(
                      'rented-properties'),
                  tabType: MyPropertiesTabs
                      .RentedProperties,
                  bookedProperties:
                      _bookedProperties,
                  inProcessProperties:
                      _inProcessProperties,
                  savedProperties:
                      _savedProperties,
                ),
                // InProcess
                MyPropertiesTabView(
                  key: ValueKey('in-process'),
                  tabType:
                      MyPropertiesTabs.InProcess,
                  bookedProperties:
                      _bookedProperties,
                  inProcessProperties:
                      _inProcessProperties,
                  savedProperties:
                      _savedProperties,
                ),
                // Saved Properties
                MyPropertiesTabView(
                  key: ValueKey(
                      'saved-properties'),
                  tabType: MyPropertiesTabs
                      .SavedProperties,
                  bookedProperties:
                      _bookedProperties,
                  inProcessProperties:
                      _inProcessProperties,
                  savedProperties:
                      _savedProperties,
                ),
                // Rejected Properties
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Container _breadCrumbs() {
  //   return Container(
  //     padding: desktopContentPadding,
  //     alignment: Alignment.centerLeft,
  //     height: 90,
  //     child: Row(
  //       children: [
  //         Icon(Icons.keyboard_arrow_left_outlined),
  //         InkWell(
  //           onTap: () {},
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: Insets.xl),
  //             child: Text(
  //               "Back to Home",
  //               style: TextStyles.body18.copyWith(color: kSupportBlue),
  //             ),
  //           ),
  //         ),
  //         VerticalDivider(
  //           width: 1,
  //           color: Colors.black,
  //           endIndent: 16,
  //           indent: 16,
  //         ),
  //         BreadCrumb(
  //           divider: Icon(Icons.chevron_right, size: 15),
  //           items: [
  //             BreadCrumbItem(
  //               content: Text(
  //                 "Dubai",
  //                 style: TextStyles.body18.copyWith(
  //                   color: kSupportBlue,
  //                   decoration: TextDecoration.underline,
  //                 ),
  //               ),
  //               onTap: () {},
  //               splashColor: kBackgroundColor,
  //               padding: EdgeInsets.symmetric(horizontal: Insets.xl),
  //             ),
  //             BreadCrumbItem(
  //               content: Text(
  //                 "Green Community",
  //                 style: TextStyles.body18.copyWith(
  //                   color: kSupportBlue,
  //                   decoration: TextDecoration.underline,
  //                 ),
  //               ),
  //               onTap: () {},
  //               splashColor: kBackgroundColor,
  //               padding: EdgeInsets.symmetric(horizontal: Insets.xl),
  //             ),
  //             BreadCrumbItem(
  //               content: Text(
  //                 "Green Park",
  //                 style: TextStyles.body18.copyWith(
  //                   color: kSupportBlue,
  //                   decoration: TextDecoration.underline,
  //                 ),
  //               ),
  //               onTap: () {},
  //               splashColor: kBackgroundColor,
  //               padding: EdgeInsets.symmetric(horizontal: Insets.xl),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  SizedBox _tabViewChild(String e) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Center(
            child: Text(e),
          ),
          SizedBox(width: 6),
          // Container(
          //   width: 8,
          //   height: 8,
          //   decoration: BoxDecoration(
          //     borderRadius: Corners.lgBorder,
          //     color: kSupportAccent,
          //   ),
          // ),
        ],
      ),
    );
  }
}
