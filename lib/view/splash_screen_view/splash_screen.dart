import 'package:construction_app/utils/approutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  String? selectedRole;

  void _onNext() async {
    if (selectedRole == 'Employee') {
      Get.toNamed(Approutes.loginScreen, arguments: {'role': 'employee'});
    } else if (selectedRole == 'Employer') {
      Get.toNamed(Approutes.loginScreen, arguments: {'role': 'employer'});
    }
  }

  Widget _buildRoleButton(String role) {
    final isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10).r,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            role,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Image.network(
                  'https://img.freepik.com/free-vector/team-concept-illustration_114360-658.jpg',
                  height: 200.h,
                ),
                SizedBox(height: 30.h),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Please select your role!',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5.h),
                Text(
                  'To Continue..',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
                ),
                SizedBox(height: 30.h),
                _buildRoleButton('Employee'),
                SizedBox(height: 16.h),
                _buildRoleButton('Employer'),
                SizedBox(height: 100.h),
                GestureDetector(
                  onTap: () async {
                    if (selectedRole == null) {
                    } else {
                      _onNext();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10).r,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: selectedRole == null
                          ? Colors.grey.shade400
                          : Colors.black,
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: selectedRole == null
                                ? Colors.grey.shade600
                                : Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
