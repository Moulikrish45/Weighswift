import 'package:flutter/material.dart';

const textinputdecoration=InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
     borderSide: BorderSide(color: Color.fromRGBO(255, 150, 143,10),width: 2,)
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(32, 149, 195, 0.8),width: 2)
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(218, 24, 24, 0.8),width: 2)
  ),

);