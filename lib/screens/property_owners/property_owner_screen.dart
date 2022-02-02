import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/dialogs/redirect_confirmation.dart';
import '../../components/footer.dart';
import '../../components/mobile_padding.dart';
import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/sliver_grid_delegate.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../routes/routes.dart';
import '../about/components/banner_image.dart';
// import 'components/banner_image.dart';
import 'components/mobile_body.dart';
import 'components/property_filter_app_bar.dart';

class PropertyOwnerScreen extends StatelessWidget {
  const PropertyOwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final searchKeywords = jsonDecode(context.vRouter.queryParameters['searchKeywordList'] ?? "");
    // searchKeywords?.removeWhere((keyword) => keyword.isEmpty);

    return PropertyOwnerView();
  }
}

class PropertyOwnerView extends StatefulWidget {
  const PropertyOwnerView({Key? key}) : super(key: key);

  @override
  _PropertyOwnerViewState createState() => _PropertyOwnerViewState();
}

class _PropertyOwnerViewState extends State<PropertyOwnerView> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  String demoString =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eu dui arcu nisl nunc bibendum in.Venenatis, sit lobortis ";

  String description =
      'Property owners have a variety of options to choose from maintaining their property to listing and negiotating directly with potential tenants. Abu Dhabi United Real Estate provides turn key solutions to meet all of our customers needs. Providing services to indviduals, private, semi-goverment, and goverment organisations. ';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("----------------------------------- Depencdency changes ------------------------------------");

    // load data for the given url
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                    imageLocation: 'assets/property_owner/property_owner.png',
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
              Text("Property Owners", style: TS.headerWhite),
              _vSpace,
              SizedBox(
                width: wp(40),
                child: Text(
                  'Turnkey Solutions for Property Owners',
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
      children: [
        Text(
          'Facility Management Service Providers',
          style: TextStyles.extraBoldh1,
        ),
        SizedBox(
          height: Insets.offset,
        ),
        Text(
          demoString + demoString,
          style: TextStyles.body14,
          maxLines: 6,
        ),
        SizedBox(
          height: Insets.xl,
        ),
      ],
    );
    Widget bannerOverImageRightBody = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Facility Management Service Providers',
          style: TextStyles.extraBoldh1,
          textAlign: TextAlign.right,
        ),
        SizedBox(
          height: Insets.offset,
        ),
        Text(
          demoString + demoString,
          style: TextStyles.body14,
          maxLines: 6,
          textAlign: TextAlign.right,
        ),
        SizedBox(
          height: Insets.xl,
        ),
      ],
    );
    //
    Widget gridItemBlue = Container(
      height: hp(2),
      width: wp(15),
      padding: EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(color: kBackgroundColor, border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: hp(15),
              width: wp(10),
              decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
              child: Icon(
                Icons.library_books_rounded,
                color: kPlainWhite,
                size: hp(7),
              )),
          SizedBox(
            height: Insets.offset,
          ),
          Text(
            'Benefit Name',
            style: TextStyles.extraBoldh1,
          ),
          SizedBox(
            height: Insets.med,
          ),
          Text(
            demoString,
            textAlign: TextAlign.center,
            style: TextStyles.body14,
          ),
        ],
      ),
    );

    Widget gridItemBrown = Container(
      height: hp(2),
      width: wp(15),
      padding: EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(color: kBackgroundColor, border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: hp(15),
              width: wp(10),
              decoration: BoxDecoration(shape: BoxShape.circle, color: kAccentColor[100]),
              child: Icon(
                Icons.library_books_rounded,
                color: kPlainWhite,
                size: hp(7),
              )),
          SizedBox(
            height: Insets.offset,
          ),
          Text(
            'Benefit Name',
            style: TextStyles.extraBoldh1,
          ),
          SizedBox(
            height: Insets.med,
          ),
          Text(
            demoString,
            textAlign: TextAlign.center,
            style: TextStyles.body14,
          ),
        ],
      ),
    );

    bannerOverStackLeftSide(String title, String des) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TS.miniHeaderBlack,
          ),
          _vExtraSpace,
          Text(
            des,
            textAlign: TextAlign.start,
            style: TS.bodyBlack,
          ),
          _vSpace,
        ],
      );
    }

    bannerOverStackRightSide(String title, String des) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TS.miniHeaderBlack,
          ),
          _vExtraSpace,
          Text(
            des,
            textAlign: TextAlign.start,
            style: TS.bodyBlack,
          ),
          _vSpace,
        ],
      );
    }

    Widget firstBannerRightSide = Stack(
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
                      'assets/service/listingmarketing.jpg',
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
                  height: 240,
                  width: wp(40),
                  decoration: BoxDecoration(color: kPlainWhite, borderRadius: Corners.lgBorder),
                  padding: EdgeInsets.only(
                    left: _hPadding,
                    right: _hPadding,
                  ),
                  child: bannerOverStackLeftSide('Managed Listing & Marketing',
                      'Our team is available to help you list your property while also ensuring that the marketing elements which include photography and digital touring are taken care off. '),
                ),
              )
            ],
          ),
        ),
      ],
    );

    Widget secondBannerLeftSide = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: wp(75),
                  height: hp(67.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/service/leasing.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: Insets.offset),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  height: 240,
                  width: wp(40),
                  decoration: BoxDecoration(color: kPlainWhite, borderRadius: Corners.lgBorder),
                  padding: EdgeInsets.only(
                    left: _hPadding,
                    right: _hPadding,
                  ),
                  alignment: Alignment.centerRight,
                  child: bannerOverStackRightSide('Lease Administration',
                      'With a list of service provider partners and our qualified team, we will manage your property from listing and marketing, inspections, contracts, rent and deposit collections, reports to maintenance, making your property management journey as digitally seemless as possible. '),
                ),
              )
            ],
          ),
        ),
      ],
    );

    Widget thirdBannerRightSide = Stack(
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
                      'assets/service/intfacility.jpg',
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
                      height: 205,
                      width: wp(40),
                      decoration: BoxDecoration(color: kPlainWhite, borderRadius: Corners.lgBorder),
                      padding: EdgeInsets.only(
                        left: _hPadding,
                        right: _hPadding,
                      ),
                      child: bannerOverStackLeftSide('Integrated Facility Management',
                          'We offer bespoke 360 degree soltuions that meet all property owners needs. ')))
            ],
          ),
        ),
      ],
    );

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
                      'assets/service/intfacility.jpg',
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
              Container(
                height: hp(47.2),
                width: wp(50),
                decoration: BoxDecoration(
                    color: kPlainWhite,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: Corners.lgBorder),
                padding: EdgeInsets.only(
                  left: Insets.xl,
                  top: Insets.offset,
                  right: Insets.xl * 5,
                ),
                child: bannerOverImageLeftBody,
              )
            ],
          ),
        ),
      ],
    );

    Widget firstGridView = Container(
      color: kBlackVariant,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset),
        child: GridView.builder(
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
            maxCrossAxisExtent: Responsive.isMobile(context) ? 382 : 450,
            mainAxisExtent: Responsive.isMobile(context) ? 445 : 400,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 0.6,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return gridItemBlue;
          },
        ),
      ),
    );

    Widget bannerContentLeftStack = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: wp(75),
                  height: hp(67.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/service/other_services_banner.png',
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: Insets.offset),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: hp(47.2),
                width: wp(50),
                decoration: BoxDecoration(
                    color: kPlainWhite,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: Corners.lgBorder),
                padding: EdgeInsets.only(
                  left: Insets.xl * 5,
                  top: Insets.offset,
                  right: Insets.xl,
                ),
                alignment: Alignment.centerRight,
                child: bannerOverImageRightBody,
              )
            ],
          ),
        ),
      ],
    );

    Widget secondGridView = Container(
      color: kBlackVariant,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset),
        child: GridView.builder(
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
            maxCrossAxisExtent: Responsive.isMobile(context) ? 382 : 450,
            mainAxisExtent: Responsive.isMobile(context) ? 445 : 400,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 0.6,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return gridItemBrown;
          },
        ),
      ),
    );

    Widget registrationSteps = Container(
      decoration: BoxDecoration(),
      child: Container(
        child: Column(
          children: [
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
                        Text(
                            'List your properties \nor choose a package that you \nare interested in exploring with us ',
                            textAlign: TextAlign.center,
                            style: TS.bodyGray),
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
                        context.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'true', 'amcType': ''});
                      },
                      onSignUp: () {
                        context.vRouter
                            .to(FacilityManagementPath, queryParameters: {'isLogin': 'false', 'amcType': ''});
                      });
                } else {
                  context.vRouter.to(FacilityManagementPath);
                }
              },
              text: "Register",
              backgroundColor: kSupportBlue,
              color: kPlainWhite,
              height: 45,
              width: 110,
              fontSize: 12,
            ),
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

    Widget pricingPlans = Container(
      height: 600,
      padding: EdgeInsets.only(
        bottom: Insets.xxl,
      ),
      decoration: BoxDecoration(
        color: kBlackVariant,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Insets.offset,
              right: Insets.offset,
              top: Insets.xl,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Packages',
              style: TS.miniHeaderWhite,
            ),
          ),
          SizedBox(
            height: Insets.xl,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(
                  left: Insets.offset * 2,
                  right: Insets.offset * 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(top: Insets.xl, left: Insets.offset),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '',
                              style: TS.miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.offset,
                            ),
                            Text(
                              'Self Managed Listing & Marketing',
                              style: TS.miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Professionally Managed Listing & Marketing',
                              style: TS.miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Lease Administration',
                              style: TS.miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Maintenance',
                              style: TS.miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Integrated Facility Management',
                              style: TS.miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            SizedBox(
                              height: Insets.offset,
                            ),
                            Text(
                              ' ',
                              style: TS.miniestHeaderWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
                        child: Container(
                          padding: EdgeInsets.only(top: Insets.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Free', style: TS.miniestHeaderWhite),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser == null) {
                                    redirectConfimationDialog(
                                        context: context,
                                        onLogin: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'true', 'amcType': 'free'});
                                        },
                                        onSignUp: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'false', 'amcType': 'free'});
                                        });
                                  } else {
                                    context.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'free'});
                                  }
                                },
                                backgroundColor: kPlainWhite,
                                color: kSupportBlue,
                                onHoverColor: kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
                        child: Container(
                          padding: EdgeInsets.only(top: Insets.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Basic', style: TS.miniestHeaderWhite),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser == null) {
                                    redirectConfimationDialog(
                                        context: context,
                                        onLogin: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'true', 'amcType': 'basic'});
                                        },
                                        onSignUp: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'false', 'amcType': 'basic'});
                                        });
                                  } else {
                                    context.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'basic'});
                                  }
                                },
                                backgroundColor: kPlainWhite,
                                color: kSupportBlue,
                                onHoverColor: kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
                        child: Container(
                          padding: EdgeInsets.only(top: Insets.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Standard', style: TS.miniestHeaderWhite),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.close,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser == null) {
                                    redirectConfimationDialog(
                                        context: context,
                                        onLogin: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'true', 'amcType': 'standard'});
                                        },
                                        onSignUp: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'false', 'amcType': 'standard'});
                                        });
                                  } else {
                                    context.vRouter
                                        .to(FacilityManagementPath, queryParameters: {'amcType': 'standard'});
                                  }
                                },
                                backgroundColor: kPlainWhite,
                                color: kSupportBlue,
                                onHoverColor: kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
                        child: Container(
                          padding: EdgeInsets.only(top: Insets.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Premium', style: TS.miniestHeaderWhite),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Icon(
                                Icons.check,
                                color: kPlainWhite,
                                size: FontSizes.s18,
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                              SizedBox(
                                height: Insets.offset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth.instance.currentUser == null) {
                                    redirectConfimationDialog(
                                        context: context,
                                        onLogin: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'true', 'amcType': 'premium'});
                                        },
                                        onSignUp: () {
                                          context.vRouter.to(FacilityManagementPath,
                                              queryParameters: {'isLogin': 'false', 'amcType': 'premium'});
                                        });
                                  } else {
                                    context.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'premium'});
                                  }
                                },
                                backgroundColor: kPlainWhite,
                                color: kSupportBlue,
                                onHoverColor: kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );

    _mobileContent() {
      return SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        mobileVerticalSizedBox,
        mobileDescription(description),
        mobileVerticalSizedBox,
        mobileStackImageBannerCard(
            ctx: context,
            imageLocation: 'assets/service/listingmarketing.jpg',
            cardHeader: 'Managed Listing & Marketing',
            cardSubHeader:
                'Our team is available to help you list your property while also ensuring that the marketing elements which include photography and digital touring are taken care off. '),
        mobileVerticalSizedBox,
        mobileStackImageBannerCard(
            ctx: context,
            imageLocation: 'assets/service/leasing.jpg',
            cardHeader: 'Lease Administration',
            cardSubHeader:
                'With a list of service provider partners and our qualified team, we will manage your property from listing and marketing, inspections, contracts, rent and deposit collections, reports to maintenance, making your property management journey as digitally seemless as possible. '),
        mobileVerticalSizedBox,
        mobileStackImageBannerCard(
            ctx: context,
            imageLocation: 'assets/service/intfacility.jpg',
            cardHeader: 'Integrated Facility Management',
            cardSubHeader: 'We offer bespoke 360 degree soltuions that meet all property owners needs. '),
        mobileVerticalSizedBox,
        mobilePricingPlan(context),
        mobileVerticalSizedBox,
        getRegisteredBody(header: 'Get Registered In 3 Steps', context: context),
      ]));
    }

    return Visibility(
      visible: Responsive.isMobile(context),
      child: SafeArea(
          child: SliverScaffold(
              title: 'Property Owners',
              imageLocation: 'assets/property_owner/property_owner.png',
              isSearch: false,
              child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  color: kBackgroundColor,
                  child: _mobileContent()))),
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
                child: Text(description, textAlign: TextAlign.center, maxLines: 3, style: TS.bodyGray),
              ),
              SizedBox(
                height: Insets.xxl,
              ),
              firstBannerRightSide,
              SizedBox(
                height: Insets.xxl,
              ),
              secondBannerLeftSide,
              SizedBox(
                height: Insets.xxl,
              ),
              thirdBannerRightSide,
              SizedBox(
                height: Insets.xxl,
              ),
              pricingPlans,
              SizedBox(
                height: Insets.xxl,
              ),
              registrationSteps,
              SizedBox(
                height: Insets.xxl,
              ),
              servicesStatusBar,
              Footer()
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyOwnerMobileScreen extends StatelessWidget {
  const PropertyOwnerMobileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // TODO: add banner image
            Column(
              children: [
                Text('Property Owners'),
                Text('lorem ipsum'),
              ],
            )
          ],
        ),
        SizedBox(height: 12),
        Text('lorem ipsum'),
      ],
    );
  }
}
