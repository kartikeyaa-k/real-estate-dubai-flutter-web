import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../app/bloc/rep_bloc.dart';
import '../core/utils/responsive.dart';
import '../core/utils/styles.dart';
import '../routes/routes.dart';
import '../screens/my_properties/my_properties_screen.dart';
import '../screens/my_services/my_services_screen.dart';
import '../screens/user_profile/user_profile.dart';
import 'buttons/primary_button.dart';

class ToolBar extends StatefulWidget implements PreferredSizeWidget {
  ToolBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(100);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          InkWell(
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
              // child: Image(
              //   image: AssetImage('assets/app/logo.png'),
              //   filterQuality: FilterQuality.none,
              //   fit: BoxFit.contain,
              //   height: 94,
              //   width: 94,
              // ),
            ),
          ),
          // SizedBox(height: 10, width: 18),
          // DropdownButton<String>(
          //   hint: Text('Choose Language'),
          //   value: choosenValue,
          //   onChanged: (newValue) {},
          //   icon: Icon(Icons.arrow_drop_down),
          //   items: _dropdownMenuItems,
          // ),
          SizedBox(width: 23),
          // Properties
          _actionButton("Properties", () {
            context.vRouter.to(PropertyListingScreenPath);
          }),
          // Projects
          _actionButton(
            "Projects",
            () {
              context.vRouter.to(ProjectListingScreenPath);
            },
          ),
          _actionButton(
            "Service Providers",
            () {
              context.vRouter.to(ServiceProviderScreenPath);
            },
          ),

          // _actionButton(
          //   (AppLocalizations.of(context)!.translate('Community Guides')).toString(),
          //   () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CommunityListingScreen(),
          //       ),
          //     );
          //   },
          // ),

          _actionButton(
            'Property Owners',
            () {
              context.vRouter.to(PropertyOwnerPath);
            },
          ),
          _actionButton(
            "Community Guides",
            () {
              context.vRouter.to(CommunityGuidlinePath);
            },
          ),
          _actionButton(
            "Services",
            () {
              context.vRouter.to(ServiceMainScreenPath);
            },
          ),
          // _actionButton(
          //   "My Properties",
          //   () {
          //     context.vRouter.to(MyPropertiesScreenPath);
          //   },
          // ),

          Spacer(flex: 6),
          // ConstrainedBox(
          //   constraints: BoxConstraints(
          //     minWidth: 70,
          //     maxWidth: 100,
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       _notificationButton(
          //         context,
          //         Icons.sms_outlined,
          //         '2',
          //       ),
          //       _notificationButton(
          //         context,
          //         Icons.bookmark_outline_sharp,
          //         '3',
          //       ),
          //     ],
          //   ),
          // ),
          Spacer(flex: 1),
          if (user != null)
            _userToolbarMenu()
          else
            PrimaryElevatedButton(
              onTap: () {
                context.vRouter.to("/login");
              },
              text: "Login/ Signup",
            ),
          Spacer()
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

  /// Contains user info such as Icon, name and email in toolbar
  Widget _userToolbarMenu() {
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
        switch (result) {
          case 0:
            context.vRouter.to(MyPropertiesScreenPath);
            break;
          case 1:
            context.vRouter.to(MyServicesScreenPath);
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
          // {'name': 'Settings', 'value': 2}
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
                      // Container(
                      //   height: 10,
                      //   width: 10,
                      //   decoration: BoxDecoration(
                      //     color: Colors.amber,
                      //     borderRadius: BorderRadius.circular(50),
                      //   ),
                      // ),
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
