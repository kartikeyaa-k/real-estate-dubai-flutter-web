import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
      child: ListView(children: <Widget>[
    ListTile(
      title: Text('Overview', style: TS.miniestHeaderBlack),
      onTap: () {},
    ),
    ListTile(
      title: Text('Location', style: TS.miniestHeaderBlack),
      onTap: () {},
    ),
    ListTile(
      title: Text('Property Details', style: TS.miniestHeaderBlack),
      onTap: () {},
    ),
  ]));
}
