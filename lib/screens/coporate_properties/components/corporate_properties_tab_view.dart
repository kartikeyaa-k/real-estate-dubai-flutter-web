import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../components/footer.dart';
import '../../../components/listing_cards/featured_card.dart';
import '../../../components/listing_cards/mobile_card.dart';
import '../../../components/sliver_grid_delegate.dart';
import '../../../components/ui_text.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../corporate_properties_screen.dart';
import 'corporate_property_filter.dart';
import 'notification_card.dart';
import 'tab_cards/corporate_common_card_mixin.dart';
import 'tab_cards/inprocess_card.dart';
import 'tab_cards/rented_card.dart';
import 'tab_cards/requested_property_card.dart';
import 'tab_cards/saved_property_card.dart';

class CorporatePropertiesTabView extends StatefulWidget {
  CorporatePropertiesTabView({Key? key, required this.tabType}) : super(key: key);
  final CorporatePropertiesTabs tabType;

  @override
  _CorporatePropertiesTabViewState createState() => _CorporatePropertiesTabViewState();
}

class _CorporatePropertiesTabViewState extends State<CorporatePropertiesTabView> with CorporateCommonCardMixin {
  Widget? mobilePriceWidget;
  Widget? mobileExtensionWidget;
  late double mobileCardHeight;
  late Widget websiteCard;
  late double maxCrossAxisExtent;
  late double mainAxisMinExtent;
  late double childAspectRatio;

  // FIXME: Gridview compress the children, avoid resizing the child
  @override
  void initState() {
    super.initState();
    initailizeCards();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: Responsive.isMobile(context)
                ? EdgeInsets.symmetric(vertical: Insets.xl, horizontal: Insets.xl)
                : EdgeInsets.symmetric(vertical: Insets.xxl / 2, horizontal: Insets.offset),
            child: Row(
              children: [
                Flexible(
                  child: NotificationCard(
                    color: Colors.amber,
                    iconData: Icons.info_outline,
                    title: "There is something wrong",
                    subTitle: "Seems like the agent dose not agree witht the price",
                  ),
                ),
              ],
            ),
          ),

          // Tablet and Desktop section
          if (!Responsive.isMobile(context))
            Container(
              padding: EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context)) ...[
                    MyPropertyFilter(),
                    SizedBox(width: 30),
                  ],
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
                        maxCrossAxisExtent: maxCrossAxisExtent,
                        mainAxisMinExtent: mainAxisMinExtent,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return websiteCard;
                      },
                    ),
                  )
                ],
              ),
            ),

          // Mobile Section
          if (Responsive.isMobile(context))
            ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: MobileCard(
                    priceWidget: mobilePriceWidget,
                    extensionWidget: mobileExtensionWidget,
                    height: mobileCardHeight,
                  ),
                ),
              ),
            ),

          // Footer
          if (Responsive.isDesktop(context)) Footer()
        ],
      ),
    );
  }

  initailizeCards() {
    switch (widget.tabType) {
      case CorporatePropertiesTabs.RentedProperties:
        // web config
        this.childAspectRatio = 394 / 441;
        this.mainAxisMinExtent = 396;
        this.maxCrossAxisExtent = 414;
        this.websiteCard = RentedCard();

        // mobile config
        this.mobileExtensionWidget = Column(
          children: [
            Divider(height: 1, color: Colors.black.withOpacity(0.2)),
            SizedBox(height: 10),
            mobileEmployeeCard(),
          ],
        );
        this.mobilePriceWidget = UiText(
          span: TextSpan(
            text: "Rent Due:",
            style: TextStyles.h3.copyWith(color: kSupportAccent),
            children: [
              TextSpan(text: " AED 1200", style: TextStyles.h3.copyWith(color: kBlackVariant)),
            ],
          ),
        );
        this.mobileCardHeight = 200;
        break;

      case CorporatePropertiesTabs.InProcess:
        // web config
        this.childAspectRatio = 394 / 481;
        this.mainAxisMinExtent = 396;
        this.maxCrossAxisExtent = 392;
        this.websiteCard = InProcessCard();

        // mobile config
        this.mobileExtensionWidget = Column(
          children: [
            Divider(height: 1, color: Colors.black.withOpacity(0.2)),
            SizedBox(height: 10),
            mobileEmployeeCard(),
          ],
        );
        this.mobilePriceWidget = Row(
          children: [
            Icon(Icons.access_time_rounded, color: kSupportBlue),
            SizedBox(width: 5),
            UiText(
              text: "10:00 - 11:00 12/11/2020",
              style: TextStyles.h4.copyWith(color: kSupportBlue),
            )
          ],
        );
        this.mobileCardHeight = 200;
        break;

      case CorporatePropertiesTabs.RequestedProperties:
        // web config
        this.childAspectRatio = 394 / 523;
        this.mainAxisMinExtent = 493;
        this.maxCrossAxisExtent = 414;
        this.websiteCard = SavedPropertyCard();

        // mobile config
        this.mobileExtensionWidget = Column(
          children: [
            Divider(height: 1, color: Colors.black.withOpacity(0.2)),
            SizedBox(height: 10),
            mobileEmployeeCard(),
          ],
        );
        this.mobilePriceWidget = null;
        this.mobileCardHeight = 200;
        break;

      case CorporatePropertiesTabs.RejectedProperties:
        // web config
        this.childAspectRatio = 394 / 493;
        this.mainAxisMinExtent = 463;
        this.maxCrossAxisExtent = 414;
        this.websiteCard = RequestedPropertyCard();

        // mobile config
        this.mobileExtensionWidget = Column(
          children: [
            Divider(height: 1, color: Colors.black.withOpacity(0.2)),
            SizedBox(height: 10),
            mobileEmployeeCard(),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: kSupportAccent, width: 1),
                borderRadius: Corners.medBorder,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                "Rejected at negotiation",
                style: TextStyles.body12.copyWith(color: kSupportAccent),
              ),
            )
          ],
        );
        this.mobilePriceWidget = null;
        this.mobileCardHeight = 240;
        break;

      default:
        this.childAspectRatio = 394 / 383;
        this.mainAxisMinExtent = 364;
        this.maxCrossAxisExtent = 414;
        this.websiteCard = FeaturedCard();
        this.mobileCardHeight = 200;
    }
  }
}
