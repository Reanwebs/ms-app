import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo('Please enter your email'));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(CommonWidgets().snackBarinfo(
          'Password reset email sent. Check your inbox.',
          color: Colors.green));
      Get.back();
      // Get.toNamed(
      //     Approutes.otpVerificationScreen); // Proceed to OTP screen (optional)
    } on FirebaseAuthException catch (e) {
      String message = "Failed to send reset email";
      if (e.code == 'invalid-email') {
        message = "Invalid email format";
      } else if (e.code == 'user-not-found') {
        message = "No user found with this email";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(CommonWidgets().snackBarinfo(message));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          CommonWidgets().snackBarinfo('An error occurred. Please try again.'));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Forgot Password'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ListView(
            children: [
              Image.network(
                'https://img.freepik.com/free-vector/forgot-password-concept-illustration_114360-1123.jpg',
                height: 200.h,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 100, color: Colors.red),
              ),
              SizedBox(height: 20.h),
              Text(
                "Forgot your password?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                "Please enter your email for verification process.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              SizedBox(height: 30.h),
              CommonWidgets().commonTextfield(
                textController: emailController,
                keyboardtype: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                hintText: 'Enter your Email',
              ),
              SizedBox(height: 30.h),
              CommonWidgets().commonButton(
                title: _isLoading ? 'Sending...' : 'Verify',
                ontap: _isLoading ? null : _sendPasswordResetEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
