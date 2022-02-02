import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/injection_container.dart';
import 'package:real_estate_portal/screens/my_services/components/my_booked_services_tab_view.dart';
import 'package:real_estate_portal/screens/my_services/components/my_complete_services_tab_view.dart';
import 'package:real_estate_portal/screens/my_services/components/my_quoted_services_tab_view.dart';
import 'package:real_estate_portal/screens/my_services/components/my_requested_services_tab_view.dart';
import 'package:real_estate_portal/screens/my_services/cubit/booked_service_cubit.dart';
import 'package:real_estate_portal/screens/my_services/cubit/completed_service_cubit.dart';
import 'package:real_estate_portal/screens/my_services/cubit/requested_service_cubit.dart';
import 'package:vrouter/vrouter.dart';
import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../property_listing/components/app_bar_bottom.dart';
import '../property_listing/components/banner_image.dart';
import 'cubit/quoted_service_cubit.dart';

enum MyServicesTabs {
  RequestedServices,
  QuotedServices,
  BookedServices,
  CompletedServices
}

class MyServiceScreen extends StatelessWidget {
  const MyServiceScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              RequestedServiceCubit(sl()),
        ),
        BlocProvider(
          create: (context) =>
              QuotedServiceCubit(sl()),
        ),
        BlocProvider(
          create: (context) =>
              BookedServiceCubit(sl()),
        ),
        BlocProvider(
          create: (context) =>
              CompletedServiceCubit(sl()),
        ),
      ],
      child: MyServiceView(),
    );
  }
}

class MyServiceView extends StatefulWidget {
  const MyServiceView({Key? key})
      : super(key: key);

  @override
  _MyServiceViewState createState() =>
      _MyServiceViewState();
}

class _MyServiceViewState
    extends State<MyServiceView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _tabList;
  final List<String> _tabString =
      MyServicesTabs.values.map((e) {
    String name = e
        .toString()
        .substring(e.toString().indexOf(".") + 1);
    return name.replaceAllMapped(
        RegExp(r'([A-Z])'), (m) => ' ${m[1]}');
  }).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: MyServicesTabs.values.length,
        vsync: this);
    _tabList = _tabString
        .map((e) => _tabViewChild(e))
        .toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<RequestedServiceCubit>()
        .loadRequestedServiceCubit();
    context
        .read<QuotedServiceCubit>()
        .loadQuoutedService();
    context
        .read<BookedServiceCubit>()
        .loadBookedServices();
    context
        .read<CompletedServiceCubit>()
        .loadCompletedServices();
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition =
        !Responsive.isMobile(context);
    final double padding = _toolBarSwitchCondition
        ? Insets.xl
        : Insets.lg;

    // App banner with tab bar
    Widget _webTabBar = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: Shadows.universal,
        borderRadius: Corners.lgBorder,
      ),
      constraints: BoxConstraints(
          maxWidth: Insets.maxWidth),
      height: 80,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: Insets.xl),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.symmetric(
            horizontal: padding),
        isScrollable:
            !Responsive.isMobile(context),
        indicatorColor: kSupportBlue,
        labelColor: Colors.black,
        unselectedLabelColor: kBlackVariant,
        labelStyle: TextStyles.h4
            .copyWith(color: kBlackVariant),
        indicatorWeight: 4,
        tabs: _tabList,
      ),
    );

    Widget _tabBarWithImageBanner = Stack(
      children: [
        Column(
          children: _toolBarSwitchCondition
              ? [
                  // if (Responsive.isDesktop(context)) PrimaryBreadCrumb(),
                  BannerImage(
                    imageLocation:
                        'assets/app/my-services-banner.jpg',
                  ),
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
              Text("My Services",
                  style: TextStyles.h2.copyWith(
                      color: Colors.white)),
              SizedBox(
                  height: _toolBarSwitchCondition
                      ? 30
                      : 18),
              if (_toolBarSwitchCondition) ...[
                _webTabBar
              ],
            ],
          ),
        )
      ],
    );

    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? ToolBar()
          : PreferredSize(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text("My Services",
                    style: TextStyles.h3.copyWith(
                        color: kBlackVariant)),
                leading: BackButton(
                  onPressed: () {
                    if (context.vRouter
                        .historyCanBack()) {
                      return context.vRouter
                          .historyBack();
                    }
                  },
                  color: kBlackVariant,
                ),
              ),
              preferredSize:
                  Size.fromHeight(kToolbarHeight),
            ),
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            if (Responsive.isMobile(context))
              SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                      child: Container(
                        color: Colors.white,
                        child: TabBar(
                          controller:
                              _tabController,
                          isScrollable: true,
                          indicatorColor:
                              kSupportBlue,
                          labelColor:
                              Colors.black,
                          unselectedLabelColor:
                              kBlackVariant,
                          labelStyle: TextStyles
                              .h4
                              .copyWith(
                                  color:
                                      kBlackVariant),
                          indicatorWeight: 4,
                          tabs: _tabList,
                        ),
                      ),
                      minExtent: 62,
                      maxExtent: 62),
                  pinned: true)
            else
              SliverToBoxAdapter(
                  child: _tabBarWithImageBanner)
          ];
        },
        body: Container(
          padding: Responsive.isMobile(context)
              ? EdgeInsets.only(top: Insets.lg)
              : null,
          child: TabBarView(
            controller: _tabController,
            children: [
              MyRequestedServicesTabView(
                  key: ValueKey(
                      'requested-services')),
              MyQuotedServicesTabView(
                  key: ValueKey(
                      'quoted-services')),
              MyBookedServicesTabView(
                  key:
                      ValueKey('booked-service')),
              MyCompletedServicesTabView(
                  key: ValueKey(
                      'complete-my-service')),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _tabViewChild(String e) {
    return SizedBox(
      child: Row(
        children: [
          Center(
            child: Text(e),
          ),
        ],
      ),
      height: 80,
    );
  }
}
