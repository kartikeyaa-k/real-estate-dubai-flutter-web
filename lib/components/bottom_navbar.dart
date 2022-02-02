import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../core/utils/styles.dart';
import '../routes/routes.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu")
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.vRouter.to(HomePath, queryParameters: {"type": "r"});
            break;
          case 1:
            context.vRouter.to(MenuPath);
            break;
          default:
        }
      },
    );
    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   height: kToolbarHeight,
    //   decoration: BoxDecoration(color: Colors.white, boxShadow: Shadows.smallReverse),
    //   child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         ...[
    //           {"icon": Icons.home, "title": "Home"},
    //           {"icon": Icons.messenger_outline, "title": "Chat"},
    //           {"icon": Icons.notifications_outlined, "title": "Notifications"},
    //           {"icon": Icons.menu, "title": "Menu"}
    //         ].map(
    //           (e) => Expanded(
    //             child: InkWell(
    //               onTap: () {},
    //               child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [Icon(e["icon"] as IconData), Text(e["title"] as String, style: TextStyles.body10)]),
    //             ),
    //           ),
    //         )
    //       ]),
    // );
  }
}
