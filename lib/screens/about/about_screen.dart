import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/footer.dart';
import 'package:real_estate_portal/components/sliver_grid_delegate.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/toolbar.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import 'components/app_bar_bottom.dart';
import 'components/banner_image.dart';
import 'components/mobile_body.dart';

import 'components/property_filter_app_bar.dart';
import 'components/sorting_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final searchKeywords = jsonDecode(context.vRouter.queryParameters['searchKeywordList'] ?? "");
    // searchKeywords?.removeWhere((keyword) => keyword.isEmpty);

    return AboutView();
  }
}

class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  String demoString =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eu dui arcu nisl nunc bibendum in.Venenatis, sit lobortis ";
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
                    imageLocation: 'assets/service/about-banner.jpg',
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
              Text("About Us", style: TS.headerWhite),
              _vSpace,
              SizedBox(
                width: wp(40),
                child: Text(
                  '',
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
          'Mission',
          style: TS.miniHeaderBlack,
        ),
        _vExtraSpace,
        Text(
          "To be a leading real estate service provider in the UAE and abroad; by offering high quality services at competitive prices aligned to international best practices; focusing on customer satisfaction and delivery of service.",
          textAlign: TextAlign.start,
          style: TS.bodyBlack,
        ),
        _vSpace,
      ],
    );
    Widget bannerOverImageRightBody = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Vision',
          style: TS.miniHeaderBlack,
        ),
        _vExtraSpace,
        Text(
          "To provide high quality real estate, building management, community management services, maintenance and home & office solutions throughout the UAE. ",
          textAlign: TextAlign.start,
          style: TS.bodyBlack,
        ),
        _vSpace,
      ],
    );
    //

    Widget cardItem(String title) {
      return Container(
        width: 260,
        height: 80,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kPlainWhite),
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.library_books_rounded,
                  color: kPlainWhite,
                )),
            SizedBox(
              width: Insets.med,
            ),
            Text(
              title,
              maxLines: 2,
              style: TS.miniestHeaderBlack,
            )
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
                      'assets/service/mission.jpg',
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
                      'assets/service/Vision.jpg',
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
                  height: 230,
                  width: wp(40),
                  decoration: BoxDecoration(color: kPlainWhite, borderRadius: Corners.lgBorder),
                  padding: EdgeInsets.only(
                    left: _hPadding,
                    right: _hPadding,
                  ),
                  alignment: Alignment.centerRight,
                  child: bannerOverImageRightBody,
                ),
              )
            ],
          ),
        ),
      ],
    );

    Widget secondGridView = Container(
      color: kBlackVariant,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _vPadding, horizontal: Insets.offset),
        child: Column(
          children: [
            Text("Our Values", style: TS.miniHeaderWhite),
            _vSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardItem(
                  'Customer satisfaction\norientated',
                ),
                _hSpace,
                cardItem(
                  'Professionalism',
                ),
                _hSpace,
                cardItem(
                  'Respect',
                ),
              ],
            ),
            _vSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardItem(
                  'Integrity',
                ),
                _hSpace,
                cardItem(
                  'Teamwork',
                ),
                _hSpace,
                cardItem(
                  'Trust & Honesty',
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Visibility(
      visible: Responsive.isMobile(context),
      child: SliverScaffold(
        child: Container(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: Insets.med),
            child: MobileBody(),
          ),
        ),
        title: "Projects",
        appBarExtension: [
          SliverPersistentHeader(
              delegate: SliverAppBarDelegate(child: AppBarBottom(), minExtent: 54, maxExtent: 54), pinned: true),
        ],
      ),
      replacement: Scaffold(
        appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Insets.xxl,
              ),
              Padding(
                padding: EdgeInsets.only(left: wp(20), right: wp(20)),
                child: Text(
                    'Abu Dhabi United Real Estate has been established since 2008 and has served as a leading member of the real estate of sector of Abu Dhabi and the UAE. Providing turn-key solutions to the property market of the UAE is our key vision serving both property owners and tenants during their tenures with us.  Our company is commited to providing a high level of service at competitive prices to all of our customers; ensuring to maintain a high level of customer satisfaction. Being a data driven organisation; has helped us maintain those levels of customer satisfaction to evaluate and optimise & improve our services along the way; ensuring to always provide a tailored experience for each of our customers to meet their needs & expectations. ',
                    textAlign: TextAlign.left,
                    maxLines: 7,
                    style: TS.bodyGray),
              ),
              SizedBox(
                height: Insets.xxl,
              ),
              // servicesStatusBar,
              SizedBox(
                height: Insets.xxl,
              ),
              bannerContentLeftStack,
              SizedBox(
                height: Insets.xxl,
              ),
              bannerContentRightStack,
              SizedBox(
                height: Insets.xxl,
              ),
              secondGridView,
              Footer()
            ],
          ),
        ),
      ),
    );
  }
}
