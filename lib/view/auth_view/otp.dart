import 'package:construction_app/utils/approutes.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    otpcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultpintheme = PinTheme(
        width: 60.w,
        height: 55.h,
        textStyle: TextStyle(color: Colors.black, fontSize: 16.sp),
        decoration: BoxDecoration(
            color: const Color(0xFFB0C7E6).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10).r,
            border: Border.all(color: Colors.transparent)));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Verify OTP'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://img.freepik.com/free-vector/two-factor-authentication-concept-illustration_114360-5488.jpg',
                  height: 200.h,
                ),
                SizedBox(height: 30.h),
                Text(
                  'Enter Verification Code',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter code that we have sent to your email',
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  child: Pinput(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      } else if (value.length != 4) {
                        return 'Enter a valid OTP of 4 digits';
                      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'OTP should contain only numbers';
                      }
                      return null;
                    },
                    length: 4,
                    defaultPinTheme: defaultpintheme,
                    pinContentAlignment: Alignment.center,
                    separatorBuilder: (index) => SizedBox(
                      width: 15.w,
                    ),
                    focusedPinTheme: defaultpintheme.copyWith(
                        decoration: defaultpintheme.decoration!
                            .copyWith(border: Border.all(color: Colors.black))),
                    onCompleted: (value) {
                      otpcontroller.text = value;
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20.h),
                CommonWidgets().commonButton(
                    title: 'Verify OTP',
                    ontap: () => Get.toNamed(Approutes.newPasswordScreen)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
