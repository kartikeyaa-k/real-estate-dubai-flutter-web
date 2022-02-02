import 'package:flutter/material.dart';
import 'package:real_estate_portal/screens/property_listing/components/app_bar_bottom.dart';
import 'package:real_estate_portal/screens/service_detail/components/service_detail_reviews.dart';

import '../../components/breadcrumb/primary_breadcrumb.dart';
import '../../components/footer.dart';
import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import 'components/service_detail_banner.dart';
import 'components/service_detail_primary_detail_card.dart';
import 'components/service_detail_side_cards.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _vSpace = Responsive(
        mobile: SizedBox(height: Insets.med),
        tablet: SizedBox(height: Insets.xl),
        desktop: SizedBox(height: Insets.xxl));
    double _offset = Responsive.isDesktop(context) ? Insets.offset : 0;

    Widget _secondaryCard = Container(
      padding: EdgeInsets.all(Insets.xl),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: !Responsive.isMobile(context) ? Corners.lgBorder : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description:", style: TextStyles.h2),
          SizedBox(height: Insets.lg),
          Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam ornare id sagittis in. Sapien mattis nunc pretium fames. Diam feugiat id nunc ultrices sit. Et neque, fringilla porttitor faucibus in scelerisque purus, aliquet. Volutpat duis turpis et pretium libero. Felis etiam et proin vel amet elit at vitae pulvinar. Enim massa, urna ut arcu lorem. Ipsum imperdiet vitae neque lorem tincidunt in. Sem aliquam at nibh penatibus lobortis. Sapien, tellus, nunc, turpis ultricies elementum. Bibendum nisl, vitae pulvinar dui natoque vitae arcu quis.",
              style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)))
        ],
      ),
    );

    Widget _mobileSecondary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_secondaryCard, SizedBox(height: Insets.med), ReviewServiceCard()],
    );

    Widget _desktopSecondary = Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 0 : Insets.xl),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 2, child: _secondaryCard),
            SizedBox(width: Insets.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ServiceCostCard(), SizedBox(height: Insets.xl), ReviewServiceCard()],
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: Responsive.isDesktop(context) ? ToolBar() : null,
      bottomNavigationBar: Responsive.isMobile(context) ? ServiceCostCard(isFixed: true) : null,
      body: ListView(
        shrinkWrap: true,
        children: [
          // if (Responsive.isDesktop(context)) PrimaryBreadCrumb(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _offset),
            child: Column(
              children: [
                ServiceDetailBanner(),
                if (!Responsive.isMobile(context)) _vSpace,
                ServiceDetailPrimaryDetailCard(),
                _vSpace,
                Responsive.isMobile(context) ? _mobileSecondary : _desktopSecondary,
                _vSpace,
                ServiceDetailReviews(),
                _vSpace
              ],
            ),
          ),
          if (Responsive.isDesktop(context)) Footer(),
        ],
      ),
    );
  }
}
