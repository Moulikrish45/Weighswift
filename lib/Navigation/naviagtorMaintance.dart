import 'package:flutter/material.dart';
import 'package:payload_detecter/MainScreen/Admin/admin.dart';
import 'package:payload_detecter/MainScreen/Contractor/Contracter.dart';
import 'package:payload_detecter/MainScreen/PayLoaders/PayloaderPage.dart';
import 'package:payload_detecter/StoreAndRetrive.dart/sharedPref.dart';

class NavigatorMaintance extends StatefulWidget {
  const NavigatorMaintance({super.key});

  @override
  State<NavigatorMaintance> createState() => _NavigatorMaintanceState();
}

class _NavigatorMaintanceState extends State<NavigatorMaintance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: SharedPref().retrieveLoginInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String? loginInfo = snapshot.data;

            if (loginInfo == "Admin") {
              print("admin");
              return Admin();
            } else if (loginInfo == "Payloader") {
              print("payloader");
              return PayloaderPage();
            } else {
              print("contractor");
              return DashBoardScreen();
            }
          }
        },
      ),
    );
  }
}
