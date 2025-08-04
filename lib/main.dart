import 'package:construction_app/utils/approutes.dart';
import 'package:construction_app/view/admin_view/admin_dashboard_view/admindashboard.dart';
import 'package:construction_app/view/employee_view/homepage_view/homepage.dart';
import 'package:construction_app/view/splash_screen_view/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for role check

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            fontFamily: GoogleFonts.dmSans().fontFamily,
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SelectRoleScreen(); // Show splash screen while checking auth
              }
              if (snapshot.hasData && snapshot.data != null) {
                // User is authenticated, check role and navigate
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot.data!.uid)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SelectRoleScreen(); // Show splash while fetching role
                    }
                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final role = userSnapshot.data!.get('role');
                      if (role == 'employer') {
                        return const DashboardPage(); // Replace with adminDashboardPage
                      } else if (role == 'employee') {
                        return const EmployeeHomePage(); // Replace with employeeHomePage
                      }
                    }
                    // If role is missing or invalid, log out and go to login
                    FirebaseAuth.instance.signOut();
                    return const SelectRoleScreen();
                  },
                );
              }
              // User is not authenticated, show role selection
              return const SelectRoleScreen();
            },
          ),
          getPages: getpages,
        );
      },
    );
  }
}
