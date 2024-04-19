// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:payload_detecter/AuthenticationPage/LoginPage.dart';

import 'package:payload_detecter/Navigation/naviagtorMaintance.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigatorMaintance();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
