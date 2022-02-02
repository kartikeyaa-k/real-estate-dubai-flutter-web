import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/bottom_navbar.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/screens/property_listing/components/banner_image.dart';
import 'package:vrouter/vrouter.dart';

class SliverScaffold extends StatefulWidget {
  /// Footer is not included in this scaffold.
  SliverScaffold({
    Key? key,
    required this.child,
    required this.title,
    this.appBarExtension,
    this.hideBottomNav = false,
    this.isSearch = true,
    this.imageLocation =
        'assets/app/banner-property-listing.png',
  }) : super(key: key);
  final Widget child;
  final String title;
  final List<Widget>? appBarExtension;
  final bool hideBottomNav;
  final String imageLocation;
  final bool isSearch;

  @override
  _SliverScaffoldState createState() =>
      _SliverScaffoldState();
}

class _SliverScaffoldState
    extends State<SliverScaffold> {
  late ScrollController _scrollController;

  double expandedHeight = 150;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset >
            (expandedHeight - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController
        .addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          !Responsive.isDesktop(context) &&
                  !widget.hideBottomNav
              ? BottomNavBar()
              : null,
      body: Builder(
        builder: (context) => NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder:
              (BuildContext context,
                  bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: context.vRouter
                        .historyCanBack()
                    ? BackButton(onPressed: () {
                        if (context.vRouter
                            .historyCanBack()) {
                          return context.vRouter
                              .historyBack();
                        }
                      })
                    : null,
                elevation: 0,
                pinned: true,
                floating: false,
                expandedHeight: expandedHeight,
                iconTheme: IconThemeData(
                  color: isShrink
                      ? kSupportBlue
                      : Colors.white,
                ),
                actions: [
                  widget.isSearch
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: isShrink
                                ? kSupportBlue
                                : Colors.white,
                          ),
                        )
                      : Container()
                ],
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  // titlePadding: EdgeInsetsDirectional.only(bottom: Insets.lg, start: Insets.med),
                  title: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyles.h5.copyWith(
                      color: isShrink
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  centerTitle: true,
                  background: BannerImage(
                    keepAspectRatio: false,
                    imageLocation:
                        widget.imageLocation,
                  ),
                ),
              ),
              if (widget.appBarExtension != null)
                ...widget.appBarExtension!
            ];
          },
          body: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context)
                  .size
                  .height,
              maxWidth: MediaQuery.of(context)
                  .size
                  .width,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
