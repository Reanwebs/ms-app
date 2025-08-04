import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/utils/approutes.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No profile data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final fullName = userData['username'] ?? 'Unknown';
          final email = userData['email'] ?? 'No email';

          final role = userData['role'] ?? 'N/A';

          final phoneNumber = userData['phone'] ?? 'N/A';

          return ListView(
            children: [
              SizedBox(height: 20.h),
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
                child: ClipOval(
                  child: SvgPicture.asset('assets/profile_icon.svg',
                      width: 80.w, height: 80.h, fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(height: 30),
              _buildInfoRow('Full Name', fullName),
              _buildInfoRow('Email ID', email),
              _buildInfoRow('Role', role),
              _buildInfoRow('Phone Number', phoneNumber),
              SizedBox(height: 30.h),
              CommonWidgets().commonButton(title: 'Edit Profile'),
              SizedBox(height: 20.h),
              CommonWidgets().commonButton(
                title: 'Logout',
                ontap: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAllNamed(Approutes.splashScreen);
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff3F72AF),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
