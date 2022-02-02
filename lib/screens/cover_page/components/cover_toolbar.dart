import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../../../app/bloc/rep_bloc.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';
import '../../my_properties/my_properties_screen.dart';
import '../../my_services/my_services_screen.dart';
import '../../user_profile/user_profile.dart';
import 'cover_nav_button.dart';

class CoverToolBar extends StatefulWidget implements PreferredSizeWidget {
  CoverToolBar(
      {Key? key,
      this.isFloorPlan = false,
      this.isPaymentPlan = false,
      required this.onGallery,
      required this.onOverview,
      required this.onFloorPlan,
      required this.onPaymentPlan,
      required this.onLocation})
      : super(key: key);
  final bool isPaymentPlan;
  final bool isFloorPlan;
  final Function onOverview;
  final Function onGallery;
  final Function onFloorPlan;
  final Function onPaymentPlan;
  final Function onLocation;
  @override
  Size get preferredSize => Size.fromHeight(100);

  @override
  _CoverToolBarState createState() => _CoverToolBarState();
}

class _CoverToolBarState extends State<CoverToolBar> {
  String selectedLanguage = 'EN';
  String? choosenValue = 'EN';

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  List<DropdownMenuItem<String>>? _dropdownMenuItems = [
    DropdownMenuItem<String>(
      value: 'AR',
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/app/uae_flag.png'),
            width: 20,
            height: 12,
          ),
          SizedBox(height: 10, width: 8),
          Text('عربي'),
        ],
      ),
    ),
    DropdownMenuItem<String>(
      value: 'EN',
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/app/en_flag.png'),
            width: 20,
            height: 12,
          ),
          SizedBox(height: 10, width: 8),
          Text('English'),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    context.vRouter.to(HomePath);
                  },
                  child: SizedBox(
                    height: 72,
                    width: 64,
                    child: SvgPicture.asset(
                      "assets/app/ADURE_LOGO.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Properties
          Row(
            children: [
              _actionButton("Overview", () {
                widget.onOverview();
              }),
              _actionButton(
                'Location',
                () {
                  widget.onLocation();
                },
              ),

              _actionButton(
                "Property Details",
                () {
                  widget.onGallery();
                },
              ),

              // widget.isFloorPlan
              //     ? _actionButton(
              //         "Floor Plan",
              //         () {
              //           widget.onFloorPlan();
              //         },
              //       )
              //     : Container(),

              // widget.isPaymentPlan
              //     ? _actionButton(
              //         "Payment Plan",
              //         () {
              //           widget.onPaymentPlan();
              //         },
              //       )
              //     : Container(),
            ],
          ),
          // Projects

          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: CoverNavButton(
                onTap: () {
                  context.vRouter.to(HomePath);
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: kPlainWhite,
                ),
                text: "Search for more properties".toUpperCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Text hyperlinks to different pages
  Widget _actionButton(
    String text,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 17, right: 17),
          alignment: Alignment.center,
          height: Insets.toolBarSize,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 32, 51, 1),
            ),
          ),
        ),
      ),
    );
  }

  Container _notificationButton(
    BuildContext context,
    IconData icon,
    String notificationCount,
  ) {
    return Container(
      height: 30,
      width: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 20,
              color: Colors.blue,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 15,
              width: 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                notificationCount,
                style: TextStyles.body10.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Contains user info such as Icon, name and email in CoverToolBar
  Widget _userCoverToolBarMenu() {
    userDetail(
      IconData endIcon, {
      double minWidth = 230,
      double maxWidth = 255,
      isMenuItem = true,
    }) =>
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? maxWidth : 50,
            minWidth: Responsive.isDesktop(context) ? minWidth : 50,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                    // backgroundImage: AssetImage('assets/app/dummy_avatar.png'),
                    ),
              ),
              if (Responsive.isDesktop(context)) ...[
                SizedBox(
                  height: 10,
                  width: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user != null) ...[
                      Text(
                        (user?.displayName?.contains(",") ?? false
                                ? user?.displayName?.split(",").first
                                : user?.displayName) ??
                            "User",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 32, 51, 1),
                        ),
                      ),
                      Text(
                        user?.email ?? "email",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 32, 51, 0.7),
                        ),
                      ),
                    ]
                  ],
                ),
                Spacer(),
                isMenuItem
                    ? Transform.rotate(
                        angle: pi / 2,
                        child: Icon(
                          endIcon,
                          size: 24,
                        ),
                      )
                    : Icon(
                        endIcon,
                        size: 24,
                      ),
              ],
            ],
          ),
        );
    // Try adding proper animation
    return PopupMenuButton(
      onSelected: (result) async {
        print(result);
        switch (result) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyPropertiesScreen(),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyServiceScreen(),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(),
              ),
            );
            break;
          case 3:
            context.read<RepBloc>().add(RepLogoutRequested());
            context.vRouter.to(LoginPath);
            break;
          default:
            print("hello");
            break;
        }
      },
      offset: Offset(0, 100),
      child: userDetail(Icons.arrow_forward_ios_sharp),
      // TODO: Try to give width 316
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          height: 78,
          child: userDetail(
            Icons.arrow_forward_ios_sharp,
            maxWidth: 316,
            minWidth: 255,
            isMenuItem: false,
          ),
        ),
        ...[
          {'name': 'My Properties', 'value': 0},
          {'name': 'Service Booked', 'value': 1},
          {'name': 'Settings', 'value': 2}
        ]
            .map(
              (e) => PopupMenuItem(
                value: e["value"],
                child: Container(
                  width: 316,
                  child: Row(
                    children: [
                      Text(e["name"].toString()),
                      Spacer(),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
        PopupMenuItem(
          value: 3,
          child: Container(
            width: 316,
            child: Row(
              children: [Text('Logout', style: TextStyles.body16), Spacer(), Icon(Icons.logout)],
            ),
          ),
        ),
      ].toList(),
    );
  }
}
