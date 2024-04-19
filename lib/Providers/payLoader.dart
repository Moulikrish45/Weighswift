import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PayloaderProvider extends ChangeNotifier {
  bool livefetchingData = false;
  double percentage = 0;
  int weight = 0;
  String trainNumber = "";
  String wagonId = "";
  bool isclick = false;
  Future<void> getliveFromServer() async {
    while (livefetchingData) {
      try {
        final response = await http.get(
            Uri.parse('http://10.10.11.94:5000/stream_weight')); //130.0.8.65
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          int weight = data['weight'];
          percentage = data['percent'];
          String trainNumber = data['train_no'];
          String wagonId = data['wegan_id'];

          isclick = false;
          print(percentage);
          notifyListeners();
        }
      } catch (error) {
        percentage = 0;
        print(error);
        return;
      }
    }
  }
}
