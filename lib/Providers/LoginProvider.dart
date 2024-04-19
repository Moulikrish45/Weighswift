
import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  String dropdownValue = "Admin";
  void updateDropdownValue(String newValue) {
    dropdownValue = newValue;
    
    notifyListeners(); 
  }
  
}
