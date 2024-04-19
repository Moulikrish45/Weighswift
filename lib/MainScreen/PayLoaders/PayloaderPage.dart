import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payload_detecter/MainScreen/PayLoaders/scanner.dart';
import 'package:payload_detecter/Providers/payLoader.dart';
import 'package:payload_detecter/AuthenticationPage/component/radial_painter.dart';

import 'package:payload_detecter/constants/constants.dart';
import 'package:provider/provider.dart';

class PayloaderPage extends StatefulWidget {
  const PayloaderPage({super.key});

  @override
  State<PayloaderPage> createState() => _PayloaderPageState();
}

class _PayloaderPageState extends State<PayloaderPage> {
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _scanQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scanner()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var payloaderProvider = Provider.of<PayloaderProvider>(context);
    double height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(appPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'find while loading ',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: appPadding,
            ),
            Container(
              margin: const EdgeInsets.all(appPadding),
              padding: const EdgeInsets.all(appPadding),
              height: 330,
              child: CustomPaint(
                foregroundPainter: RadialPainter(
                  bgColor: textColor.withOpacity(0.1),
                  lineColor: primaryColor,
                  percent: payloaderProvider.percentage / 100,
                  width: 18.0,
                ),
                child: Center(
                  child: payloaderProvider.isclick
                      ? const CircularProgressIndicator()
                      : Text(
                    "${payloaderProvider.percentage.toStringAsFixed(1)}%",
                    style: const TextStyle(
                        color: textColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.circle,
                  color: primaryColor,
                  size: 10,
                ),
                const SizedBox(
                  width: appPadding / 2,
                  height: 70,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        payloaderProvider.isclick = true;
                        payloaderProvider.livefetchingData = true;
                      });
                      await payloaderProvider.getliveFromServer();
                    } catch (error) {
                    } finally {
                      setState(() {
                        payloaderProvider.isclick = false;
                        payloaderProvider.livefetchingData = false;
                      });
                    }
                  },
                  child: Text(
                    "start",
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    signOut();
                  },
                  child: Text("signout"),
                ),
                ElevatedButton(
                  onPressed: _scanQRCode,
                  child: Text("Scan QR Code"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
