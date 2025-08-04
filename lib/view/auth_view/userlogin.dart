import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/utils/approutes.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  final dynamic arguments;
  LoginScreen({super.key}) : arguments = Get.arguments;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  Map<String, dynamic>? data;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    data = widget.arguments as Map<String, dynamic>? ??
        {'role': 'employee'}; // Default to employee if null
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo('Please enter username and password'));
      return;
    }

    try {
      log('Attempting login for username: $username');

      // Query Firestore for user with matching username and role
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .where('role', isEqualTo: data?['role'])
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            CommonWidgets().snackBarinfo('Username or role not found'));
        return;
      }

      final userData = userSnapshot.docs.first.data();
      final email = userData['email'];
      log('Found email: $email for role: ${userData['role']}');

      // Sign in with email and password
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log('Login successful for user: ${userCredential.user?.uid}');

      // Navigate based on role
      if (userData['role'] == 'employer') {
        Get.offAllNamed(Approutes.adminDashboardPage);
      } else if (userData['role'] == 'employee') {
        Get.offAllNamed(Approutes.employeeHomePage);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(CommonWidgets().snackBarinfo(message));
      log('FirebaseAuthException: ${e.code} - ${e.message}');
    } on FirebaseException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'permission-denied') {
        message = 'Access denied. Please contact support.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(CommonWidgets().snackBarinfo(message));
      log('FirebaseException: ${e.code} - ${e.message}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo('An unexpected error occurred'));
      log('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar(''),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
          child: ListView(
            children: [
              Image.network(
                'https://img.freepik.com/free-vector/login-concept-illustration_114360-757.jpg?semt=ais_hybrid&w=740',
                height: 200.h,
              ),
              SizedBox(height: 20.h),
              Text(
                "Welcome to MS App !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                "Login to your account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              SizedBox(height: 30.h),
              CommonWidgets().commonTextfield(
                textController: _usernameController,
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                hintText:
                    data?['role'] == 'employee' ? 'Username' : 'Admin Username',
              ),
              SizedBox(height: 16.h),
              CommonWidgets().commonTextfield(
                textController: _passwordController,
                obsureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                hintText: 'Password',
              ),
              SizedBox(height: 10.h),
              data?['role'] == 'employee'
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Approutes.forgotPasswordScreen);
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: 30.h),
              CommonWidgets().commonButton(title: 'Login', ontap: _handleLogin),
            ],
          ),
        ),
      ),
    );
  }
}
