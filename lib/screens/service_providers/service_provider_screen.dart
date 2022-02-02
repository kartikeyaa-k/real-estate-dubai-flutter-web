import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/bottom_navbar.dart';
import '../../components/dialogs/redirect_confirmation.dart';
import '../../components/mobile_app_bar.dart';
import '../../components/mobile_padding.dart';
import '../../components/scaffold/sliver_scaffold.dart';
import '../cover_page/components/cover_app_bar_mobile.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/footer.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../routes/routes.dart';
import 'components/banner_image.dart';
import 'components/benefits_grid_model.dart';
import 'components/mobile_body.dart';
import 'components/property_filter_app_bar.dart';

class ServiceProviderScreen extends StatelessWidget {
  const ServiceProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final searchKeywords = jsonDecode(context.vRouter.queryParameters['searchKeywordList'] ?? "");
    // searchKeywords?.removeWhere((keyword) => keyword.isEmpty);

    return ServiceProviderView();
  }
}

class ServiceProviderView extends StatefulWidget {
  const ServiceProviderView({Key? key}) : super(key: key);

  @override
  _ServiceProviderViewState createState() => _ServiceProviderViewState();
}

class _ServiceProviderViewState extends State<ServiceProviderView> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  String demoString =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eu dui arcu nisl nunc bibendum in.Venenatis, sit lobortis ";

  List<BenefitsModel> gridItemList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("----------------------------------- Depencdency changes ------------------------------------");

    // load data for the given url
  }

  @override
  void initState() {
    super.initState();
    addGridItem();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  addGridItem() {
    gridItemList.add(BenefitsModel(
        iconColor: kSupportBlue,
        header: 'Business Development',
        subHeader: 'Build your client base, brand and business growth'));

    gridItemList.add(BenefitsModel(
        iconColor: kSupportBlue,
        header: 'Flexibility',
        subHeader: 'Provide access to maintain your work schedule around the properties you service'));

    gridItemList.add(BenefitsModel(
        iconColor: kSupportBlue,
        header: 'Business acceleration',
        subHeader: 'A suite of business tools provided through our portal; makes full-filling orders easier.'));
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);
    final _vMinSpace = SizedBox(
      height: Insets.sm,
    );
    final _vSpace = SizedBox(
      height: Insets.xl,
    );

    final _vExtraSpace = SizedBox(
      height: Insets.offset,
    );
    final _hSpace = SizedBox(
      width: Insets.xl,
    );
    final _hPadding = Insets.offset;
    final _hSmallPadding = Insets.xl;
    final _vPadding = Insets.xl;

    Widget stack = Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: _toolBarSwitchCondition
              ? [
                  BannerImage(
                    imageLocation: 'assets/service/services-banner.jpg',
                  )
                ]
              : [],
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Service Providers", style: TS.headerWhite),
              _vSpace,
              SizedBox(
                width: wp(40),
                child: Text(
                  'Offer Services to Property Owners With Ease',
                  textAlign: TextAlign.center,
                  style: TS.bodyWhite,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );

    Widget bannerOverImageLeftBody = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Service Providers',
          style: TS.miniHeaderBlack,
        ),
        _vExtraSpace,
        Text(
          "Abu Dhabi United Real Estate invites professional service providers; who share the same values as us in providing services of high excellence to tenants; in providing services to meet their needs. ",
          textAlign: TextAlign.start,
          style: TS.bodyBlack,
        ),
        _vSpace,
      ],
    );

    Widget gridItem(Color cicleColor, String title, String description) {
      return Container(
        height: 255,
        width: Responsive.isTablet(context) ? wp(23) : wp(20),
        padding: EdgeInsets.only(
          left: _hSmallPadding,
          right: _hSmallPadding,
          top: _hSmallPadding,
        ),
        decoration: BoxDecoration(color: kBackgroundColor, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: hp(6),
                width: wp(6),
                decoration: BoxDecoration(shape: BoxShape.circle, color: cicleColor),
                child: Icon(
                  Icons.library_books_rounded,
                  color: kPlainWhite,
                  size: hp(4),
                )),
            _vSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TS.miniHeaderBlack,
            ),
            _vSpace,
            Text(
              description,
              textAlign: TextAlign.center,
              style: TS.bodyBlack,
            ),
          ],
        ),
      );
    }

    Widget bannerContentRightStack = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  width: wp(75),
                  height: hp(67.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/service/service-providers.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Insets.offset),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  height: 250,
                  width: wp(40),
                  decoration: BoxDecoration(color: kPlainWhite, borderRadius: Corners.lgBorder),
                  padding: EdgeInsets.only(
                    left: _hPadding,
                    right: _hPadding,
                  ),
                  child: bannerOverImageLeftBody,
                ),
              )
            ],
          ),
        ),
      ],
    );

    Widget firstGridView = Container(
      color: kBlackVariant,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _vPadding, horizontal: Insets.offset),
        child: Column(
          children: [
            Text("Benefits for Service Providers", style: TS.miniHeaderWhite),
            _vSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gridItem(kSupportBlue, 'Business Development', 'Build your client base, brand and business growth'),
                _hSpace,
                gridItem(kSupportBlue, 'Flexibility',
                    'Provide access to maintain your work schedule around the properties you service'),
                _hSpace,
                gridItem(kSupportBlue, 'Business acceleration',
                    ' A suite of business tools provided through our portal; makes full-filling orders easier. '),
              ],
            ),
          ],
        ),
      ),
    );

    Widget registrationSteps = Container(
      decoration: BoxDecoration(),
      child: Container(
        child: Column(
          children: [
            _vExtraSpace,
            Text(
              'Get registered in 3 steps'.toUpperCase(),
              style: TS.miniHeaderBlack,
            ),
            _vSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: hp(10),
                    width: wp(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
                    child: Text(
                      '1',
                      textAlign: TextAlign.center,
                      style: TS.headerWhite,
                    )),
                Container(
                  width: wp(15),
                  decoration: BoxDecoration(border: Border.all(color: kSupportBlue, width: 2)),
                ),
                Container(
                    height: hp(10),
                    width: wp(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
                    child: Text(
                      '2',
                      textAlign: TextAlign.center,
                      style: TS.headerWhite,
                    )),
                Container(
                  width: wp(15),
                  decoration: BoxDecoration(border: Border.all(color: kSupportBlue, width: 2)),
                ),
                Container(
                    height: hp(10),
                    width: wp(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
                    child: Text(
                      '3',
                      textAlign: TextAlign.center,
                      style: TS.headerWhite,
                    )),
              ],
            ),
            _vSpace,
            Padding(
              padding: EdgeInsets.only(left: wp(17), right: wp(17)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Login & Apply',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderBlack,
                        ),
                        _vSpace,
                        Text(
                          'Register with us',
                          textAlign: TextAlign.center,
                          style: TS.bodyGray,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Get Approval',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderBlack,
                        ),
                        _vSpace,
                        Text(
                          'Our team will verify your account',
                          textAlign: TextAlign.center,
                          style: TS.bodyGray,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Get Listed',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderBlack,
                        ),
                        _vSpace,
                        Text('List your services', textAlign: TextAlign.center, style: TS.bodyGray),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _vExtraSpace,
            PrimaryButton(
              onTap: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  redirectConfimationDialog(
                      context: context,
                      onLogin: () {
                        context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'isLogin': 'true'});
                      },
                      onSignUp: () {
                        context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'isLogin': 'false'});
                      });
                } else {
                  context.vRouter.to(ServiceRegistrationScreenPath);
                }
              },
              text: "Register",
              backgroundColor: kSupportBlue,
              color: kPlainWhite,
              height: 45,
              width: 110,
              fontSize: 12,
            ),
            _vExtraSpace,
          ],
        ),
      ),
    );

    Widget servicesStatusBar = Container(
      decoration: BoxDecoration(
        color: kAccentColor[100],
      ),
      padding: EdgeInsets.only(
        top: _hPadding,
        bottom: _hPadding,
      ),
      alignment: Alignment.center,
      child: Container(
          padding: EdgeInsets.only(left: _hPadding * 2, right: _hPadding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '25+',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderWhite,
                        ),
                        _vMinSpace,
                        Text(
                          'Communities Managed',
                          textAlign: TextAlign.center,
                          style: TS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                    _vExtraSpace,
                    Column(
                      children: [
                        Text(
                          '10000+',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderWhite,
                        ),
                        _vMinSpace,
                        Text(
                          'No. of Tenants',
                          textAlign: TextAlign.center,
                          style: TS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '2500+',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderWhite,
                        ),
                        _vMinSpace,
                        Text(
                          'Properties Managed',
                          textAlign: TextAlign.center,
                          style: TS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                    _vExtraSpace,
                    Column(
                      children: [
                        Text(
                          '100000+',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderWhite,
                        ),
                        _vMinSpace,
                        Text(
                          'No. of Maintenance\ntasks completed',
                          textAlign: TextAlign.center,
                          style: TS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '150+',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderWhite,
                        ),
                        _vMinSpace,
                        Text(
                          'No. of owners served',
                          textAlign: TextAlign.center,
                          style: TS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                    _vExtraSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '50000+',
                          textAlign: TextAlign.center,
                          style: TS.miniHeaderWhite,
                        ),
                        _vMinSpace,
                        Text(
                          'Properties Managed',
                          textAlign: TextAlign.center,
                          style: TS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );

    Widget _mobileContent() {
      return SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // mobileStackBannerImage(
        //     imageLocation: 'assets/service/services-banner.jpg',
        //     header: 'Service Provider ',
        //     subHeader: 'Offer Services to Property Owners With Eases'),
        mobileVerticalSizedBox,
        mobileStackImageBannerCard(
          ctx: context,
          imageLocation: 'assets/service/service-providers.jpg',
          cardHeader: 'Service Providers',
          cardSubHeader:
              "Abu Dhabi United Real Estate invites professional service providers; who share the same values as us in providing services of high excellence to tenants; in providing services to meet their needs. ",
        ),
        mobileVerticalSizedBox,
        mobileHorizontalList(gridItemList),
        mobileVerticalSizedBox,
        getRegisteredBody(header: 'Get Registered In 3 Steps', context: context),
        mobileVerticalSizedBox,
      ]));
    }

    return Responsive.isMobile(context)
        ? SafeArea(
            child: SliverScaffold(
                title: 'Service Providers',
                imageLocation: 'assets/service/services-banner.jpg',
                isSearch: false,
                child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    color: kBackgroundColor,
                    child: _mobileContent())))
        : Visibility(
            visible: Responsive.isMobile(context),
            child: Scaffold(
              body: ServiceProviderMobileView(),
            ),
            replacement: Scaffold(
              appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    stack,
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wp(20), right: wp(20)),
                      child: Text('', textAlign: TextAlign.center, maxLines: 3, style: TS.bodyGray),
                    ),
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    bannerContentRightStack,
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    firstGridView,
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    // bannerContentLeftStack,
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    // secondGridView,
                    registrationSteps,
                    servicesStatusBar,
                    Footer()
                  ],
                ),
              ),
            ),
          );
  }
}

class ServiceProviderMobileView extends StatelessWidget {
  const ServiceProviderMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            BannerImage(
              imageLocation: 'assets/service/service-providers.jpg',
            ),
            Column(
              children: [
                Text('Service Providers'),
                SizedBox(height: 12),
                Text('lorem ipsum dolor sit am consehi uaihsa'),
              ],
            )
          ],
        ),
        SizedBox(height: 12),
        Text('lorem ipsum dolor sit amet consehiuaihsa'),
        SizedBox(height: 12),
        Stack(
          children: [
            Column(),
            Card(
              child: Column(
                children: [
                  Text('Facility Management Service Providers'),
                  Text('Lorem impsum'),
                  ElevatedButton(onPressed: () {}, child: Text('Register')),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            children: [
              Text('Benefit for manager service providers'),
              // TODO: add scrollable
            ],
          ),
        ),
        SizedBox(height: 12),
        Stack(
          children: [
            Column(),
            Card(
              child: Column(
                children: [
                  Text('Other Service Providers'),
                  Text('Lorem impsum'),
                  ElevatedButton(onPressed: () {}, child: Text('Register')),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            children: [
              Text('Benefit for other service providers'),
              // TODO: add scrollable
            ],
          ),
        ),
        SizedBox(height: 12),
        Column(
          children: [
            Text('GET REGISTERD IN 3 STEPS'),
            // TODO: add stepper here
            ElevatedButton(
              onPressed: () {},
              child: Text('Register'),
            )
          ],
        ),
        SizedBox(height: 12),
        GridView.count(crossAxisCount: 2, children: [
          Column(
            children: [
              Text('245'),
              Text('Facility Manager'),
            ],
          ),
          Column(
            children: [
              Text('160'),
              Text('Other Service Provider'),
            ],
          ),
          Column(
            children: [
              Text('3255'),
              Text('Total Workforce'),
            ],
          ),
          Column(
            children: [
              Text('45'),
              Text('Satisfied Customer'),
            ],
          ),
        ]),
      ],
    );
  }
}
