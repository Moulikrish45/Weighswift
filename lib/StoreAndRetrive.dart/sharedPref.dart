import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> saveDataUser(String type, String Email) async {
    print(Email);
    print(type);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences saveEmail = await SharedPreferences.getInstance();
    saveEmail.setString('Email', Email);
    prefs.setString(Email, type);
  }

  Future<String> retrieveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences savedEmail = await SharedPreferences.getInstance();
    String Email = savedEmail.getString('Email') ?? '';
    String? type = prefs.getString(Email)??'';
    print(Email);
    print(type);
    return type ;
  }
}
