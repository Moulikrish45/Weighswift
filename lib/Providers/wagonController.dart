import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:payload_detecter/AuthenticationPage/component/snackbar.dart';
import 'package:payload_detecter/global.dart';


class wagonController extends ChangeNotifier {
  bool fetchingdata = false;
  bool livefetchingdata = false;
  bool livefetchingIndicator = false;
  List<int> list = [];
  int overload = 0;
  int underload = 0;
  int totalwagon = 0;
  int totalweight = 0;
  double percentage = 0;
  String formattedDate = "";
  String wagonId = "";
  String uid = "";
  String trainId = "";
  bool isClick = false;
  bool connectionLost = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // getting data
  Future<void> getWeightFromServer() async {
    while (fetchingdata) {
      try {
        final response = await http.get(Uri.parse(
            'http://10.10.11.94:5000/get_weight?userId=${uid}')); //130.0.8.65
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          int weight = data['weight'];
          wagonId = data['wegan_id'];
          trainId = data['train_no'];
          list.add(weight);
          totalwagon = list.length;
          totalweight += weight;
          isClick = false;
          if (weight > GlobalData().OverLoad) {
            overload++;
          } else if (weight < GlobalData().underload) {
            underload++;
          }

          addWeightToFirestore(weight);
          notifyListeners();
        }
      } catch (error) {
        connectionLost = true;
        print(error);
        return;
      }
    }
  }

  Future<void> addWeightToFirestore(int weight) async {
    DateTime currentDate = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd HH').format(currentDate);
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid = user.uid;

        // Create a reference to the user's document in the "Train Informations" collection
        DocumentReference userWeightRef =
            _firestore.collection('Train Informations').doc("userid : $uid");

        // Create a new document within the "Train id" collection
        DocumentReference train = userWeightRef
            .collection('Train Details')
            .doc("${trainId}- ${formattedDate}");

        DocumentReference wagon =
            train.collection("Wagon Details").doc('${wagonId}');

        // Add the weight to the user's document
        await wagon.set({
          'wagon id': wagonId,
          'weight': weight,
          'Load': (weight > GlobalData().OverLoad)
              ? 'overload'
              : (weight < GlobalData().underload)
                  ? 'underload'
                  : 'exact load',
        });

        // Notify listeners after successfully adding the weight
        notifyListeners();
      } else {
        print('User not logged in');
      }
    } catch (error) {
      print('Error adding weight to Firestore: $error');
    }
  }

  Future<void> clear(BuildContext context) async {
    if (!list.isEmpty) {
      try {
        DocumentReference userWeightRef =
            _firestore.collection('Train Informations').doc("userid : $uid");

        // Create a new document within the "Train id" collection
        DocumentReference train = userWeightRef
            .collection('Train Details')
            .doc("${trainId}- ${formattedDate}");
        await train.set({
          'no of overload': overload,
          'no of underload': underload,
          'Total Weight': totalweight,
          'TrainId&Time': "${trainId}- ${formattedDate}"
        });
        overload = underload = totalwagon = totalweight = 0;
        trainId = "";
        list.clear();
        notifyListeners();
      } catch (error) {
        print(error);
      }
    } else {
      CustomSnackBar.showError(context, "no Datas are available");
    }
  }
}
