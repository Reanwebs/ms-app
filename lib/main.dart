
import 'package:construction_app/view/login.dart';
import 'package:construction_app/view/sign_up.dart';
import 'package:construction_app/view/userlogin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

     
      home:  SelectRoleScreen(),
    );
  }
}
