import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payload_detecter/AuthenticationPage/DropDown.dart';
import 'package:payload_detecter/AuthenticationPage/component/my_button.dart';
import 'package:payload_detecter/AuthenticationPage/component/my_textfield.dart';

import 'package:payload_detecter/AuthenticationPage/snackbar.dart';
import 'package:payload_detecter/Providers/LoginProvider.dart';
import 'package:payload_detecter/StoreAndRetrive.dart/sharedPref.dart';

import 'package:payload_detecter/constants/constants.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> check(
      String Collection, BuildContext context, String Email) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(Collection)
          .doc(Email)
          .get();
      if (documentSnapshot.exists) {
        _login(context, Email, Collection);
      } else {
        CustomSnackBar.showError(context, "user not available");
      }
    } catch (error) {
      CustomSnackBar.showError(context, error.toString());
    }
  }

  Future<void> _login(BuildContext context, String Email, String type) async {
    SharedPref sh = SharedPref();
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await _auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      sh.saveDataUser(type, Email);
    } catch (e) {
      // Print detailed error information
      print('Error during login: $e');

      // Handle specific error cases
      if (e is FirebaseAuthException) {
        // Handle FirebaseAuthException
        if (e.code == 'user-not-found') {
          CustomSnackBar.showError(context, "User not found");
        } else if (e.code == 'wrong-password') {
          CustomSnackBar.showError(context, "Wrong password");
        } else {
          CustomSnackBar.showError(context, "Login failed. Please try again.");
        }
      } else {
        // Handle other types of errors
        CustomSnackBar.showError(
            context, "An unexpected error occurred. Please try again.");
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var loginProvider = Provider.of<LoginProvider>(context);
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    String dropdownvalue = 'Admin';

    // List of items in our dropdown menu

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width < 1000 ? width * 0.1 : width * 0.30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Image.asset(
                    'assets/images/logowithtext.png',
                    height: height * 0.2,
                  ),

                  const SizedBox(height: 50),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),
                  DropDown(),

                  // username tex tfield
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                      onTap: () => check(loginProvider.dropdownValue, context,
                          usernameController.text)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
