import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';
import 'banner_card.dart';
import 'home_filter.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Image with gradient
    Widget bannerImage = Stack(
      children: [
        AspectRatio(
          aspectRatio: !Responsive.isMobile(context) ? 1366 / 519 : 4 / 2.7,
          child: Image.asset(
            "assets/app/banner.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        // Container(
        //   height: !Responsive.isMobile(context) ? 520 : 202,
        //   decoration:
        //       BoxDecoration(image: DecorationImage(image: AssetImage('assets/app/banner.jpg'), fit: BoxFit.cover)),
        // ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kBlackVariant, kBlackVariant.withOpacity(0)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ],
    );

    // Mobile banner card row
    Widget mobileBannerCard = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 474, minWidth: 328),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BannerCard(
                text: "Residential",
                onTap: () {
                  context.vRouter.to(PropertyListingScreenPath, queryParameters: {"type": "r"});
                },
                child: Image.asset(
                  'assets/app/house.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: BannerCard(
                text: "Commercial",
                onTap: () {
                  context.vRouter.to(PropertyListingScreenPath, queryParameters: {"type": "c"});
                },
                child: Image.asset(
                  'assets/app/corporate.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget _homeScreenTitle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Properties Just For You", style: TextStyles.body16.copyWith(color: Colors.white)),
        SizedBox(height: Responsive.isMobile(context) ? 12 : 20),
        Text("Search For Your Dream Property",
            style: Responsive.isMobile(context)
                ? TextStyles.h3.copyWith(color: Colors.white)
                : TextStyles.h1.copyWith(color: Colors.white),
            textAlign: TextAlign.center),
        SizedBox(height: Responsive.isMobile(context) ? 12 : 20),
        PrimaryButton(
          onTap: () {
            context.vRouter.to(CoverPath);
          },
          height: Responsive.isMobile(context) ? null : 48,
          text: "Visit Qaryat Al Hidd",
        )
      ],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            bannerImage,

            // this size box adjusts the bottom of stack so that [HomeFilter] can be placed at over banner image
            SizedBox(
              height: !Responsive.isMobile(context)
                  ? Responsive.isTablet(context)
                      ? 77
                      : 122
                  : 52,
            ),
          ],
        ),
        // Desktop HomeFilter rendered else mobile BannerCards
        if (Responsive.isDesktop(context)) ...[
          Positioned(
            top: 120,
            child: _homeScreenTitle,
          ),
          HomeFilter(selectedTab: context.vRouter.queryParameters["type"] ?? "r")
        ] else
          Positioned(
            left: 0,
            bottom: 0,
            top: 16,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(child: _homeScreenTitle),
                  ),
                  SizedBox(height: Responsive.isMobile(context) ? 16 : 40),
                  Align(
                    child: mobileBannerCard,
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
