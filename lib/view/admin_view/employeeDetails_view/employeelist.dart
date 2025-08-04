import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  // Helper method to format time string to DateTime for comparison
  DateTime? _parseTimeString(String? time, DateTime today) {
    if (time == null || time == '--:--') return null;
    try {
      final format =
          DateFormat('h:mm a'); // Assuming time is in "h:mm a" format
      final parsedTime = format.parse(time);
      return DateTime(
        today.year,
        today.month,
        today.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      developer.log('Error parsing time: $e');
      return null;
    }
  }

  // Method to determine status based on attendance
  Future<String> _getEmployeeStatus(String userId, DateTime today) async {
    try {
      final dateStr =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final doc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .collection('records')
          .doc(dateStr)
          .get();

      if (!doc.exists) {
        return 'Inactive'; // No attendance record for today
      }

      final data = doc.data()!;
      final checkInTime = data['checkInTime'] as String?;
      final checkOutTime = data['checkOutTime'] as String?;

      if (checkInTime == null) {
        return 'Inactive'; // No check-in today
      }

      final now = DateTime.now();
      final parsedCheckIn = _parseTimeString(checkInTime, today);
      final parsedCheckOut = _parseTimeString(checkOutTime, today);

      if (parsedCheckIn == null || parsedCheckIn.isAfter(now)) {
        return 'Inactive'; // Invalid check-in or in the future
      }

      if (checkOutTime == null || parsedCheckOut == null) {
        return 'Active'; // Checked in, no check-out
      }

      return parsedCheckOut.isBefore(now) ? 'Inactive' : 'Active';
    } catch (e) {
      developer.log('Error fetching status for user $userId: $e');
      return 'Inactive'; // Default to Inactive on error
    }
  }

  // Method to fetch siteName from today's attendance record
  Future<String> _getEmployeeSite(String userId, DateTime today) async {
    try {
      final dateStr =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final doc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .collection('records')
          .doc(dateStr)
          .get();

      if (doc.exists && doc.data()!['site_name'] != null) {
        return doc.data()!['site_name'] as String;
      }

      // Fallback to the site field in the users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc.data()?['site'] ?? 'N/A';
    } catch (e) {
      developer.log('Error fetching site for user $userId: $e');
      return 'N/A'; // Default to N/A on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Employee Details'),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Employee List',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'employee')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No employees found'));
                    }

                    final employees = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: employees.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final employee =
                            employees[index].data() as Map<String, dynamic>;
                        final userId = employees[index].id;
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffCCE4FF),
                              borderRadius: BorderRadius.circular(10).r),
                          margin: const EdgeInsets.only(bottom: 16).r,
                          child: Padding(
                            padding: const EdgeInsets.all(12).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow("Name", employee['username'] ?? 'N/A'),
                                const SizedBox(height: 6),
                                _infoRow("Role", employee['role'] ?? 'N/A'),
                                const SizedBox(height: 6),
                                _infoRow("Email", employee['email'] ?? 'N/A'),
                                const SizedBox(height: 6),
                                _infoRow(
                                    "Phone Number", employee['phone'] ?? 'N/A'),
                                const SizedBox(height: 6),
                                // Status row with FutureBuilder
                                FutureBuilder<String>(
                                  future: _getEmployeeStatus(
                                      userId, DateTime.now()),
                                  builder: (context, statusSnapshot) {
                                    String status = 'Inactive';
                                    if (statusSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      status = 'Loading...';
                                    } else if (statusSnapshot.hasData) {
                                      status = statusSnapshot.data!;
                                    }
                                    return _infoRow("Status", status);
                                  },
                                ),
                                const SizedBox(height: 6),
                                // Site row with FutureBuilder
                                FutureBuilder<String>(
                                  future:
                                      _getEmployeeSite(userId, DateTime.now()),
                                  builder: (context, siteSnapshot) {
                                    String site = 'N/A';
                                    if (siteSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      site = 'Loading...';
                                    } else if (siteSnapshot.hasData) {
                                      site = siteSnapshot.data!;
                                    }
                                    return _infoRow("Site", site);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: label == 'Status' && value == 'Active'
                  ? Colors.green
                  : label == 'Status' && value == 'Inactive'
                      ? Colors.red
                      : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
