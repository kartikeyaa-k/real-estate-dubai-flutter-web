import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'buttons/custom_icon_button.dart';
import 'skeleton_image_loader.dart';
import '../core/utils/constants.dart';
import '../core/utils/responsive.dart';
import '../core/utils/styles.dart';
import 'snack_bar/custom_snack_bar.dart';

class CompanyBanner extends StatefulWidget {
  const CompanyBanner(
      {Key? key,
      required this.coverImage,
      this.agentPhone,
      required this.agencyName,
      required this.agentName,
      this.customPadding})
      : super(key: key);
  final String coverImage;
  final String? agentPhone;
  final String agencyName;
  final String agentName;
  final double? customPadding;

  @override
  State<CompanyBanner> createState() =>
      _CompanyBannerState();
}

class _CompanyBannerState
    extends State<CompanyBanner> {
  bool phoneNumberVisible = false;

  @override
  Widget build(BuildContext context) {
    double mobileLeftRightPadding = Insets.med;
    double mobileTopBottomPadding = Insets.med;
    print(
        '#log : circle avatarr ${widget.coverImage}');
    double _padding = widget.customPadding != null
        ? Insets.xxl
        : Responsive.isMobile(context)
            ? Insets.lg
            : Insets.xl;

    Widget _mobile_CompanyLogoAndName = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: Responsive.isMobile(context)
              ? 20
              : 25,
          child: SkeletonImageLoader(
              borderRadius: Corners.xlBorder,
              image: widget.coverImage),
        ),
        SizedBox(width: mobileTopBottomPadding),
        Flexible(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text("Property By",
                  style: MS.bodyGray),
              SizedBox(height: 2),
              Container(
                child: Text(widget.agencyName,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: MS.miniHeaderBlack),
              )
            ],
          ),
        )
      ],
    );

    Widget _mobile_PropertyAgentName = Row(
      mainAxisAlignment:
          Responsive.isMobile(context)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 4,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SelectableText(widget.agentName,
                  style: MS.miniHeaderBlack),
              SizedBox(height: Insets.sm),
              Text("Trusted Agent",
                  style: MS.bodyBlack.copyWith(
                      color: kSupportGreen))
            ],
          ),
        ),
        Spacer(),
        phoneNumberVisible
            ? GestureDetector(
                onTap: () async {
                  await launch(
                      widget.agentPhone ?? "");
                  setState(() {
                    phoneNumberVisible =
                        !phoneNumberVisible;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Times.fast,
                  width: 170,
                  height:
                      Responsive.isMobile(context)
                          ? 45
                          : 50,
                  decoration: BoxDecoration(
                      color: kPlainWhite,
                      boxShadow: Shadows.small,
                      border: Border.all(
                          width: 1,
                          color: kSupportBlue),
                      borderRadius:
                          BorderRadius.circular(
                              8)),
                  child: SizedBox(
                    height: 24,
                    child: SelectableText(
                      widget.agentPhone ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      style:
                          TS.miniestHeaderBlack,
                    ),
                  ),
                ))
            : CustomIconButton(
                child: Icon(Icons.phone_in_talk,
                    color: kSupportBlue),
                onTap: () async {
                  await launch(
                      widget.agentPhone ?? "");
                  setState(() {
                    phoneNumberVisible =
                        !phoneNumberVisible;
                  });

                  print(
                      '#log -> ${widget.agentPhone}');
                },
              ),
        // SizedBox(width: _padding),
        // CustomIconButton(child: Icon(Icons.message_outlined, color: kSupportBlue)),
      ],
    );

    Widget _companyLogoAndName = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 25,
          child: SkeletonImageLoader(
              borderRadius: Corners.xlBorder,
              image: widget.coverImage),
        ),
        SizedBox(width: Insets.lg),
        Flexible(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text("Property By",
                  style: TextStyles.body12
                      .copyWith(
                          color: kBlackVariant
                              .withOpacity(0.7))),
              SizedBox(height: Insets.sm),
              Container(
                child: Text(widget.agencyName,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyles.h3),
              )
            ],
          ),
        )
      ],
    );

    Widget _propertyAgentName = Row(
      children: [
        Flexible(
          flex: 4,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(widget.agentName,
                  style: TextStyles.h3),
              SizedBox(height: Insets.sm),
              Text("Trusted Agent",
                  style: TextStyles.body12
                      .copyWith(
                          color: kSupportGreen))
            ],
          ),
        ),
        Spacer(),
        phoneNumberVisible
            ? InkWell(
                onTap: () {
                  Clipboard.setData(
                          new ClipboardData(
                              text: widget
                                  .agentPhone))
                      .then((_) {
                    SnackBar snackBar = CustomSnackBar
                        .successSnackBar(
                            "Phone number copied to clipboard");
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  });
                  setState(() {
                    phoneNumberVisible =
                        !phoneNumberVisible;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Times.fast,
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                      color: kPlainWhite,
                      boxShadow: Shadows.small,
                      border: Border.all(
                          width: 1,
                          color: kSupportBlue),
                      borderRadius:
                          BorderRadius.circular(
                              8)),
                  child: SizedBox(
                    height: 24,
                    child: Text(
                      "+97150 323 9811",
                      // widget.agentPhone ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          TS.miniestHeaderBlack,
                    ),
                  ),
                ))
            : CustomIconButton(
                child: Icon(Icons.phone_in_talk,
                    color: kSupportBlue),
                onTap: () {
                  setState(() {
                    phoneNumberVisible =
                        !phoneNumberVisible;
                  });

                  print(
                      '#log -> ${widget.agentPhone}');
                },
              ),
        // SizedBox(width: _padding),
        // CustomIconButton(child: Icon(Icons.message_outlined, color: kSupportBlue)),
      ],
    );

    return Container(
      padding: Responsive.isMobile(context)
          ? EdgeInsets.all(mobileTopBottomPadding)
          : EdgeInsets.all(_padding),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              Responsive.isDesktop(context)
                  ? Corners.lgBorder
                  : null),
      child: Responsive.isTablet(context)
          ? Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _companyLogoAndName,
                      SizedBox(height: _padding),
                    ],
                  ),
                ),
                SizedBox(width: Insets.offset),
                Expanded(
                    child: _propertyAgentName),
              ],
            )
          : Responsive.isMobile(context)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _mobile_CompanyLogoAndName,
                    SizedBox(
                        height:
                            mobileTopBottomPadding),
                    _mobile_PropertyAgentName,
                  ],
                )
              : Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _companyLogoAndName,
                    SizedBox(height: _padding),
                    _propertyAgentName,
                    widget.customPadding != null
                        ? Container()
                        : SizedBox(
                            height: _padding),
                  ],
                ),
    );
  }
}
