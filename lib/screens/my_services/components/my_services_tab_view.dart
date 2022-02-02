import 'package:flutter/material.dart';

import '../../../components/footer.dart';
import '../../../components/sliver_grid_delegate.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../my_services_screen.dart';
import 'my_services_card.dart';
import 'my_services_mobile_card.dart';

class MyServicesTabView extends StatefulWidget {
  MyServicesTabView({Key? key, required this.tabType}) : super(key: key);
  final MyServicesTabs tabType;

  @override
  _MyServicesTabViewState createState() => _MyServicesTabViewState();
}

class _MyServicesTabViewState extends State<MyServicesTabView> {
  late Widget mobileCard;
  late Widget websiteCard;
  late double maxCrossAxisExtent;
  late double mainAxisMinExtent;
  late double childAspectRatio;

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
          // Tablet and Desktop section
          if (!Responsive.isMobile(context))
            Padding(
              padding: EdgeInsets.symmetric(vertical: Insets.xxl, horizontal: Insets.offset),
              child: GridView.builder(
                primary: false,
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
            ),

          // Mobile Section
          if (Responsive.isMobile(context))
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // appState.currentAction = PageAction(state: PageState.addPage, page: propertyDetailPageConfig);
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: mobileCard,
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
      case MyServicesTabs.BookedServices:
        // web config
        this.childAspectRatio = 394 / 393;
        this.mainAxisMinExtent = 393;
        this.maxCrossAxisExtent = 500;
        this.websiteCard = MyServicesCard(showBottom: true, chips: [
          Chip(
              visualDensity: VisualDensity.compact,
              label: Text("Booked", style: TextStyles.body10.copyWith(color: Colors.white)),
              backgroundColor: kSupportGreen)
        ]);

        this.mobileCard = MyServicesMobileCard(
          imageUrl:
              "https://www.rocketmortgage.com/resources-cmsassets/RocketMortgage.com/Article_Images/Large_Images/TypesOfHomes/contemporary-house-style-9.jpg",
          text: "House Cleaning",
          cost: "AED 120/Hr",
          subHeading: Row(
            children: [
              Icon(Icons.schedule_outlined, color: Colors.white),
              Text("Today 10:00 - 11-00", style: TextStyles.body16.copyWith(color: Colors.white))
            ],
          ),
        );
        break;

      // case MyServicesTabs.RequestedServices:
      //   // web config
      //   this.childAspectRatio = 340 / 293;
      //   this.mainAxisMinExtent = 343;
      //   this.maxCrossAxisExtent = 500;
      //   this.websiteCard = RequestedServiceCard(
      //     description: "lorem ipsum",
      //     chips: [
      //       Chip(
      //           visualDensity: VisualDensity.compact,
      //           label: Text("Requested", style: TextStyles.body10.copyWith(color: Colors.white)),
      //           backgroundColor: kSupportBlue)
      //     ],
      //   );

      //   this.mobileCard = MyServicesMobileCard(
      //     imageUrl: "https://images.indianexpress.com/2019/12/Home-Decor-2020-Trends_759.jpg",
      //     text: "House Cleaning",
      //     cost: "AED 120/Hr",
      //   );
      //   break;

      case MyServicesTabs.QuotedServices:
        // web config
        this.childAspectRatio = 370 / 343;
        this.mainAxisMinExtent = 393;
        this.maxCrossAxisExtent = 500;
        this.websiteCard = MyServicesCard(showBottom: false, buttonText: "View Quote");

        this.mobileCard = MyServicesMobileCard(
          imageUrl:
              "https://media.angi.com/s3fs-public/styles/widescreen_large/s3/s3fs-public/home-garden.JPG?37enwB2E.rbKnI5YrW6JZ_irCpGbr5ct&itok=Usbna66n",
          text: "House Cleaning",
          subHeading: Row(
            children: [
              Expanded(flex: 8, child: Text("Quoted Price", style: TextStyles.h5.copyWith(color: Colors.white))),
              Spacer(),
              Text("AED 120/Hr", style: TextStyles.body14.copyWith(color: Colors.white))
            ],
          ),
        );
        break;

      case MyServicesTabs.CompletedServices:
        // web config
        this.childAspectRatio = 370 / 343;
        this.mainAxisMinExtent = 343;
        this.maxCrossAxisExtent = 500;
        this.websiteCard = MyServicesCard();

        this.mobileCard = MyServicesMobileCard(
          imageUrl:
              "https://media.angi.com/s3fs-public/styles/widescreen_large/s3/s3fs-public/home-garden.JPG?37enwB2E.rbKnI5YrW6JZ_irCpGbr5ct&itok=Usbna66n",
          text: "House Cleaning",
          cost: "AED 120/Hr",
        );
        break;
    }
  }
}
