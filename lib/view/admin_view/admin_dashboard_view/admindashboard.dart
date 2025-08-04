import 'package:construction_app/utils/approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const SizedBox(),
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Text(
            'Admin Dashboard',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
          child: ListView(
            children: [
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAddButton(context, Icons.person_add, "Add Employee",
                      () {
                    Get.toNamed(Approutes.adminAddEmployee);
                  }),
                  _buildAddButton(context, Icons.construction, "Add Tools", () {
                    Get.toNamed(Approutes.adminAddTools);
                  }),
                  _buildAddButton(context, Icons.home_work, "Add Site", () {
                    Get.toNamed(Approutes.adminAddSite);
                  }),
                ],
              ),
              SizedBox(height: 30.h),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 30.h),
              // Clickable containers
              _buildClickableContainer(context, "Employees details ", () {
                Get.toNamed(Approutes.adminEmployeeDetails);
              }),
              SizedBox(height: 15.h),
              _buildClickableContainer(context, "Active Tools", () {
                Get.toNamed(Approutes.adminToolsManagement);
              }),
              SizedBox(height: 15.h),
              _buildClickableContainer(context, "View Sites", () {
                Get.toNamed(Approutes.adminSitesManagement);
              }),
              SizedBox(height: 15.h),
              _buildClickableContainer(context, "Logout", () async {
                FirebaseAuth.instance.signOut();
                Get.offAllNamed(Approutes.splashScreen);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Material(
          elevation: 6,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12).r,
          shadowColor: Colors.grey.withOpacity(0.4),
          child: InkWell(
            onTap: onTap, // use the passed onTap
            borderRadius: BorderRadius.circular(12).r,
            child: Container(
              width: 60.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Icon(icon, color: Colors.black, size: 24.w),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildClickableContainer(
    BuildContext context,
    String title,
    VoidCallback onTap, // Add onTap as a parameter
  ) {
    return InkWell(
      onTap: onTap, // Use the passed onTap
      borderRadius: BorderRadius.circular(12).r,
      splashColor: const Color(0xff3F72AF).withOpacity(0.2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15).r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12).r,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18.w)
          ],
        ),
      ),
    );
  }
}
