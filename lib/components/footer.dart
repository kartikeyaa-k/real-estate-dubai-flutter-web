import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../core/localization/app_localizations.dart';
import '../core/utils/styles.dart';
import '../routes/routes.dart';
import 'logo.dart';

class Footer extends StatefulWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    Container footerShareAndSearch = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "   Social",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.vRouter.toExternal("https://www.facebook.com/adurecom", openNewTab: true);
                },
                icon: SizedBox(
                  width: 11,
                  height: 20,
                  child: Icon(FeatherIcons.facebook, color: Colors.white),
                ),
              ),
              // SizedBox(width: 38),
              IconButton(
                onPressed: () {
                  context.vRouter.toExternal("https://www.instagram.com/adurecom/?hl=en", openNewTab: true);
                },
                icon: SizedBox(
                  width: 22,
                  height: 17.94,
                  child: Icon(FeatherIcons.instagram, color: Colors.white),
                ),
              ),
              // SizedBox(width: 38),
              IconButton(
                onPressed: () {
                  context.vRouter.toExternal(
                      "https://www.linkedin.com/company/abu-dhabi-united-real-estate-company-llc",
                      openNewTab: true);
                },
                icon: SizedBox(
                  width: 22,
                  height: 17.94,
                  child: Icon(FeatherIcons.linkedin, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 353,
      color: Color(0xFF060606),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 100,
          // start: 100,
          end: 100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Logo(size: 150, type: LogoType.light),
            footerColumn(
              context,
              (AppLocalizations.of(context)!.translate("Quick Links")).toString(),
              [
                _FooterItem(
                  title: "Home",
                  onTap: () {
                    context.vRouter.to(HomePath);
                  },
                ),
                _FooterItem(
                  title: "Properties",
                  onTap: () {
                    context.vRouter.to(PropertyListingScreenPath);
                  },
                ),
                _FooterItem(
                  title: "Projects",
                  onTap: () {
                    context.vRouter.to(ProjectListingScreenPath);
                  },
                ),
                _FooterItem(
                  title: "Service Provider",
                  onTap: () {
                    context.vRouter.to(ServiceProviderScreenPath);
                  },
                ),
                _FooterItem(
                  title: "Property Owners",
                  onTap: () {
                    context.vRouter.to(PropertyOwnerPath);
                  },
                ),
                _FooterItem(
                  title: "About",
                  onTap: () {
                    context.vRouter.to(AboutPath);
                  },
                ),
              ],
            ),
            // footerColumn(
            //   context,
            //   (AppLocalizations.of(context)!.translate("Location")).toString(),
            //   [
            //     (AppLocalizations.of(context)!.translate("UAE")).toString(),
            //     (AppLocalizations.of(context)!.translate("USA")).toString(),
            //     (AppLocalizations.of(context)!.translate("India")).toString(),
            //   ],
            // ),
            footerColumn(
              context,
              "Search",
              [
                _FooterItem(
                  title: "Residential Buy",
                  onTap: () {
                    context.vRouter.to(HomePath, queryParameters: {"type": "r"});
                  },
                ),
                _FooterItem(
                  title: "Residential Rent",
                  onTap: () {
                    context.vRouter.to(HomePath, queryParameters: {"type": "r"});
                  },
                ),
                _FooterItem(
                  title: "Commercial Buy",
                  onTap: () {
                    context.vRouter.to(HomePath, queryParameters: {"type": "c"});
                  },
                ),
                _FooterItem(
                  title: "Commercial Rent",
                  onTap: () {
                    context.vRouter.to(HomePath, queryParameters: {"type": "c"});
                  },
                ),
              ],
            ),
            footerShareAndSearch
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Column footerColumn(
    BuildContext context,
    String title,
    List<_FooterItem> linkList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.h3.copyWith(color: Colors.white),
        ),
        SizedBox(height: 12),
        ...linkList.map(
          (e) => footerLinks(e.title, context, e.onTap),
        ),
      ],
    );
  }

  InkWell footerLinks(String e, BuildContext context, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(
          e,
          style: TextStyles.body14.copyWith(color: Colors.white70),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }
}

class _FooterItem {
  final String title;
  final VoidCallback onTap;

  _FooterItem({required this.title, required this.onTap});
}
