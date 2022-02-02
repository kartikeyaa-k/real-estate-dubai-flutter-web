import 'package:flutter/material.dart';
import '../../../../core/utils/styles.dart';

mixin CorporateCommonCardMixin {
  Widget employeeCard() => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/app/dummy_avatar.png'),
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cameron Williamson',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 32, 51, 1),
                ),
              ),
              Text(
                'alma.lawson@example.com',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 32, 51, 0.7)),
              )
            ],
          ),
        ],
      );

  Widget mobileEmployeeCard() => Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/app/dummy_avatar.png'),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Cameron Williamson',
            overflow: TextOverflow.ellipsis,
            style: TextStyles.body16,
          )
        ],
      );
}
