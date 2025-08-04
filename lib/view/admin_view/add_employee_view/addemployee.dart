import 'package:construction_app/controller/admin_controller/admin_controller.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AdminController adminController = Get.put(AdminController());

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Add Employee'),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
            child: ListView(
              children: [
                Center(
                  child: Image.network(
                    'https://img.freepik.com/free-vector/devices-concept-illustration_114360-90.jpg',
                    height: 200.h,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Enter Employee Details",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                CommonWidgets().commonTextfield(
                  textController: _usernameController,
                  hintText: 'Enter Username',
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                CommonWidgets().commonTextfield(
                  textController: _emailController,
                  hintText: 'Enter Email Address',
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                CommonWidgets().commonTextfield(
                  textController: _mobileController,
                  hintText: 'Enter Mobile Number',
                  prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length < 10) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                CommonWidgets().commonTextfield(
                  textController: _passwordController,
                  hintText: 'Enter Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30.h),
                Obx(
                  () => CommonWidgets().commonButton(
                    title: adminController.isloading.value
                        ? 'Creating Employee..'
                        : 'Submit',
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
                        var status = await adminController.createEmployee(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _usernameController.text.trim(),
                            _mobileController.text.trim(),
                            context);
                        if (status == true) {
                          CommonWidgets().successAlertBox(
                            context,
                            'Employee Created Successfully!',
                          );
                        }
                      }
                    },
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
