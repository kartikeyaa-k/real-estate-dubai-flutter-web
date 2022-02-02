import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:real_estate_portal/models/response_models/my_properties/booked_properties_response_model.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../components/footer.dart';
import '../../../components/listing_cards/featured_card.dart';

import '../../../components/sliver_grid_delegate.dart';
import '../../../components/ui_text.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

import '../my_properties_screen.dart';
import '../property_website_card.dart';

import 'property_mobile_card.dart';

class MyPropertiesTabView extends StatefulWidget {
  MyPropertiesTabView(
      {Key? key,
      required this.tabType,
      required this.bookedProperties,
      required this.inProcessProperties,
      required this.savedProperties,
      this.tabFirstError = false,
      this.tabSecondError = false,
      this.tabThirdError = false})
      : super(key: key);
  final MyPropertiesTabs tabType;
  final List<BookedPropertiesModel>
      bookedProperties;
  final List<BookedPropertiesModel>
      inProcessProperties;
  final List<BookedPropertiesModel>
      savedProperties;
  final bool tabFirstError;
  final bool tabSecondError;
  final bool tabThirdError;
  @override
  _MyPropertiesTabViewState createState() =>
      _MyPropertiesTabViewState();
}

class _MyPropertiesTabViewState
    extends State<MyPropertiesTabView> {
  Widget? mobilePriceWidget;
  Widget? mobileExtensionWidget;
  late Widget websiteCard;
  late double maxCrossAxisExtent;
  late double mainAxisMinExtent;
  late double childAspectRatio;

  // FIXME: Gridview compress the children, avoid resizing the child
  @override
  void initState() {
    super.initState();

    variableMobileValues();
    variableDesktopValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   padding: Responsive.isMobile(context)
            //       ? EdgeInsets.symmetric(
            //           vertical: Insets.xl, horizontal: Insets.xl)
            //       : EdgeInsets.symmetric(
            //           vertical: Insets.xxl / 2, horizontal: Insets.offset),
            //   child: Row(
            //     children: [
            //       Flexible(
            //         child: NotificationCard(
            //           color: Colors.amber,
            //           iconData: Icons.info_outline,
            //           title: "There is something wrong",
            //           subTitle:
            //               "Seems like the agent dose not agree witht the price",
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Tablet and Desktop section
            if (!Responsive.isMobile(context))
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: Insets.xxl,
                    horizontal: Insets.offset),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // if (Responsive.isDesktop(context)) ...[
                    //   MyPropertyFilter(),
                    //   SizedBox(width: 30),
                    // ],

                    variableDesktopValues()
                  ],
                ),
              ),

            // Mobile Section
            if (Responsive.isMobile(context))
              variableMobileValues(),

            // Footer
            if (Responsive.isDesktop(context))
              Footer()
          ],
        ),
      ),
    );
  }

  variableMobileValues() {
    switch (widget.tabType) {
      case MyPropertiesTabs.RentedProperties:
        this.childAspectRatio = 394 / 383;
        this.mainAxisMinExtent = 364;
        this.maxCrossAxisExtent = 414;
        this.mobileExtensionWidget = null;
        this.mobilePriceWidget = UiText(
          span: TextSpan(
            text: "Rent Due:",
            style: TextStyles.h3
                .copyWith(color: kSupportAccent),
            children: [
              TextSpan(
                  text: " AED 1200",
                  style: TextStyles.h3.copyWith(
                      color: kBlackVariant)),
            ],
          ),
        );

        if (widget.bookedProperties.isEmpty) {
          return _PropertyEmpty();
        } else if (widget.tabFirstError) {
          return _PropertyDetailError();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount:
              widget.bookedProperties.length,
          itemBuilder: (context, index) =>
              GestureDetector(
            onTap: () {
              context.vRouter.to(
                  PropertyDetailScreenPath,
                  queryParameters: {
                    "id": widget
                        .bookedProperties[index]
                        .propertyId as String
                  });
            },
            child: Padding(
                padding:
                    EdgeInsets.only(bottom: 2),
                child: PropertyMobileCard(
                  key: ValueKey(widget
                      .bookedProperties[index]
                      .propertyId),
                  image: widget
                      .bookedProperties[index]
                      .coverImage,
                  name: widget
                      .bookedProperties[index]
                      .propertyName,
                  address: widget
                      .bookedProperties[index]
                      .address,
                  price: widget
                      .bookedProperties[index]
                      .price,
                )),
          ),
        );

      case MyPropertiesTabs.InProcess:
        this.childAspectRatio = 394 / 421;
        this.mainAxisMinExtent = 364;
        this.maxCrossAxisExtent = 420;
        this.mobileExtensionWidget = null;
        this.mobilePriceWidget = Row(
          children: [
            Icon(Icons.access_time_rounded,
                color: kSupportBlue),
            SizedBox(width: 5),
            UiText(
              text: "10:00 - 11:00 12/11/2020",
              style: TextStyles.h4
                  .copyWith(color: kSupportBlue),
            )
          ],
        );
        if (widget.inProcessProperties.isEmpty) {
          return _PropertyEmpty();
        } else if (widget.tabSecondError) {
          return _PropertyDetailError();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount:
              widget.inProcessProperties.length,
          itemBuilder: (context, index) =>
              GestureDetector(
            onTap: () {
              context.vRouter.to(
                  PropertyDetailScreenPath,
                  queryParameters: {
                    "id": widget
                        .bookedProperties[index]
                        .propertyId as String
                  });
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: PropertyMobileCard(
                image: widget
                    .inProcessProperties[index]
                    .coverImage,
                name: widget
                    .inProcessProperties[index]
                    .agencyName,
                address: widget
                    .inProcessProperties[index]
                    .address,
                price: widget
                    .inProcessProperties[index]
                    .price,
              ),
            ),
          ),
        );

      case MyPropertiesTabs.SavedProperties:
        this.childAspectRatio = 394 / 459;
        this.mainAxisMinExtent = 394;
        this.maxCrossAxisExtent = 414;
        this.mobileExtensionWidget = null;
        this.mobilePriceWidget = null;
        if (widget.savedProperties.isEmpty) {
          return _PropertyEmpty();
        } else if (widget.tabThirdError) {
          return _PropertyDetailError();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount:
              widget.savedProperties.length,
          itemBuilder: (context, index) =>
              GestureDetector(
            onTap: () {
              context.vRouter.to(
                  PropertyDetailScreenPath,
                  queryParameters: {
                    "id": widget
                        .bookedProperties[index]
                        .propertyId as String
                  });
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: PropertyMobileCard(
                image: widget
                    .savedProperties[index]
                    .coverImage,
                name: widget
                    .savedProperties[index]
                    .agencyName,
                address: widget
                    .savedProperties[index]
                    .address,
                price: widget
                    .savedProperties[index].price,
              ),
            ),
          ),
        );

      // case MyPropertiesTabs.RejectedProperties:
      //   this.childAspectRatio = 394 / 493;
      //   this.mainAxisMinExtent = 463;
      //   this.maxCrossAxisExtent = 414;
      //   this.mobileExtensionWidget = Container(
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       border: Border.all(color: kSupportAccent, width: 1),
      //       borderRadius: Corners.medBorder,
      //     ),
      //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      //     child: Text(
      //       "Rejected at negotiation",
      //       style: TextStyles.body12.copyWith(color: kSupportAccent),
      //     ),
      //   );
      //   this.mobilePriceWidget = null;
      //   // this.websiteCard = RejectedPropertyCard();
      //   return ListView.builder(
      //     shrinkWrap: true,
      //     itemCount: widget.savedProperties.length,
      //     itemBuilder: (context, index) => GestureDetector(
      //       onTap: () {
      //         context.vRouter.to(PropertyDetailScreenPath, queryParameters: {
      //           "id": widget.bookedProperties[index].propertyId as String
      //         });
      //       },
      //       child: Padding(
      //         padding: EdgeInsets.only(bottom: 2),
      //         child: PropertyMobileCard(
      //           image: widget.savedProperties[index].coverImage,
      //           name: widget.savedProperties[index].agencyName,
      //           address: widget.savedProperties[index].address,
      //           price: widget.savedProperties[index].price,
      //         ),
      //       ),
      //     ),
      //   );

      default:
        this.childAspectRatio = 394 / 383;
        this.mainAxisMinExtent = 364;
        this.maxCrossAxisExtent = 414;
        this.websiteCard = FeaturedCard();
    }
  }

  variableDesktopValues() {
    switch (widget.tabType) {
      case MyPropertiesTabs.RentedProperties:
        return Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
              maxCrossAxisExtent:
                  maxCrossAxisExtent,
              mainAxisMinExtent:
                  mainAxisMinExtent,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: childAspectRatio,
            ),
            itemCount:
                widget.bookedProperties.length,
            itemBuilder: (context, index) {
              return PropertyWebsiteCard(
                key: ValueKey(widget
                    .bookedProperties[index]
                    .propertyId),
                onViewDetails: () {
                  context.vRouter.to(
                      PropertyDetailScreenPath,
                      queryParameters: {
                        "id": widget
                            .bookedProperties[
                                index]
                            .propertyId
                            .toString()
                      });
                },
                image: widget
                    .bookedProperties[index]
                    .coverImage,
                name: widget
                    .bookedProperties[index]
                    .propertyName,
                address: widget
                    .bookedProperties[index]
                    .address,
                price: widget
                    .bookedProperties[index]
                    .price,
              );
            },
          ),
        );

      case MyPropertiesTabs.InProcess:
        return Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
              maxCrossAxisExtent:
                  maxCrossAxisExtent,
              mainAxisMinExtent:
                  mainAxisMinExtent,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: childAspectRatio,
            ),
            itemCount:
                widget.inProcessProperties.length,
            itemBuilder: (context, index) {
              return PropertyWebsiteCard(
                onViewDetails: () {
                  context.vRouter.to(
                      PropertyDetailScreenPath,
                      queryParameters: {
                        "id": widget
                            .bookedProperties[
                                index]
                            .propertyId
                            .toString()
                      });
                },
                image: widget
                    .inProcessProperties[index]
                    .coverImage,
                name: widget
                    .inProcessProperties[index]
                    .propertyName,
                address: widget
                    .inProcessProperties[index]
                    .address,
                price: widget
                    .inProcessProperties[index]
                    .price,
              );
            },
          ),
        );

      case MyPropertiesTabs.SavedProperties:
        return Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
              maxCrossAxisExtent:
                  maxCrossAxisExtent,
              mainAxisMinExtent:
                  mainAxisMinExtent,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: childAspectRatio,
            ),
            itemCount:
                widget.savedProperties.length,
            itemBuilder: (context, index) {
              return PropertyWebsiteCard(
                onViewDetails: () {
                  context.vRouter.to(
                      PropertyDetailScreenPath,
                      queryParameters: {
                        "id": widget
                            .bookedProperties[
                                index]
                            .propertyId
                            .toString()
                      });
                },
                image: widget
                    .savedProperties[index]
                    .coverImage,
                name: widget
                    .savedProperties[index]
                    .propertyName,
                address: widget
                    .savedProperties[index]
                    .address,
                price: widget
                    .savedProperties[index].price,
              );
            },
          ),
        );

      // case MyPropertiesTabs.RejectedProperties:
      //   return Flexible(child: Container());

      default:
        this.childAspectRatio = 394 / 383;
        this.mainAxisMinExtent = 364;
        this.maxCrossAxisExtent = 414;
        this.websiteCard = FeaturedCard();
    }
  }
}

class _PropertyEmpty extends StatelessWidget {
  const _PropertyEmpty({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              height: 400,
              child: Center(
                child: Text(
                  'There are no properties yet in this section.',
                  maxLines: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyDetailLoading
    extends StatelessWidget {
  const _PropertyDetailLoading({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.all(Insets.offset),
            child: SizedBox(
                height: 400,
                child: Center(
                    child: SpinKitThreeBounce(
                        color: kSupportBlue))),
          ),
        ],
      ),
    );
  }
}

class _PropertyDetailError
    extends StatelessWidget {
  const _PropertyDetailError(
      {Key? key,
      this.errorMessage =
          'Oops! Something went wrong! '})
      : super(key: key);
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(Insets.offset),
        child: Center(
          child: Flexible(
              child: Text(
            errorMessage,
            style: TS.bodyBlack
                .copyWith(color: kErrorColor),
          )),
        ));
  }
}
