import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payload_detecter/MainScreen/Contractor/drawer_list_tile.dart';
import 'package:payload_detecter/constants/constants.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(appPadding),
            child: Image.asset("assets/images/logowithtext.png"),
          ),
          DrawerListTile(
              title: 'Dash Board',
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {}),
         const  Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Logout',
              svgSrc: 'assets/icons/Logout.svg',
              tap: () {
                logout();
              }),
        ],
      ),
    );
  }

  Future<void> logout() async {
    print("logout");
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error during logout: $e");
      // Handle the error, if any.
    }
  }
}
