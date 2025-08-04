import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeToolsPage extends StatefulWidget {
  const EmployeeToolsPage({super.key});

  @override
  State<EmployeeToolsPage> createState() => _EmployeeToolsPageState();
}

class _EmployeeToolsPageState extends State<EmployeeToolsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> filteredTools = [];
  Timer? _debounce;
  String? selectedTab;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _descriptionController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          'Tools',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: 'All Tools'),
            Tab(text: 'My Tools'),
            Tab(text: 'Requested Tools'),
          ],
          unselectedLabelStyle: TextStyle(
              fontSize: 12.sp, fontFamily: GoogleFonts.dmSans().fontFamily),
          labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: GoogleFonts.dmSans().fontFamily,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Tools Tab
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tools')
                .where('status', isEqualTo: 'available')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No tools available'));
              }
              final tools = snapshot.data!.docs;

              // Filter tools based on search query
              filteredTools = tools.where((doc) {
                final toolData = doc.data() as Map<String, dynamic>;
                final name = toolData['name']?.toString().toLowerCase() ?? '';
                final code = toolData['code']?.toString().toLowerCase() ?? '';
                final type = toolData['type']?.toString().toLowerCase() ?? '';

                final searchMatch =
                    name.contains(_searchController.text.toLowerCase()) ||
                        code.contains(_searchController.text.toLowerCase()) ||
                        type.contains(_searchController.text.toLowerCase());

                final tabMatch = selectedTab == null || selectedTab == 'All'
                    ? true
                    : toolData['type']?.toString().toLowerCase() ==
                        selectedTab!.toLowerCase();

                return searchMatch && tabMatch;
              }).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)
                          .r,
                      child: CommonWidgets().commonTextfield(
                        hintText: 'Search Tool/Material',
                        textController: _searchController,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        onchanged: (p0) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 300), () {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        padding: const EdgeInsets.only(left: 20).r,
                        itemBuilder: (context, index) {
                          final categroyname = ['All', 'Tool', 'Material'];
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: _buildTab(categroyname[index]),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20)
                          .r,
                      itemCount: filteredTools.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final tool =
                            filteredTools[index].data() as Map<String, dynamic>;
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffCCE4FF),
                              borderRadius: BorderRadius.circular(10).r),
                          margin: const EdgeInsets.only(bottom: 16).r,
                          child: Padding(
                            padding: const EdgeInsets.all(12).r,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8).r,
                                  child: Image.memory(
                                    base64Decode(tool['imageData'] ?? ''),
                                    height: 60.h,
                                    width: 60.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tool['name'] ?? 'N/A',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 2.5.h),
                                      Text("ID: ${tool['code'] ?? 'N/A'}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(height: 2.5.h),
                                      Text("Type: ${tool['type'] ?? 'N/A'}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(height: 2.5.h),
                                      Text("Count: ${tool['count'] ?? 0}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(height: 2.5.h),
                                      Text(
                                          "Status: ${tool['status'] ?? 'Unknown'}",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: _getStatusColor(
                                                  tool['status'] ??
                                                      'Unknown'))),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    CommonWidgets().showFeedbackDialogue(
                                      context,
                                      _descriptionController,
                                      () async {
                                        await FirebaseFirestore.instance
                                            .collection('tool_requests')
                                            .add({
                                          'toolName': tool['name'],
                                          'toolId': tool['code'],
                                          'type': tool['type'],
                                          'quantity': 1,
                                          'description':
                                              _descriptionController.text,
                                          'employeeId': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'status': 'pending',
                                          'created_at':
                                              FieldValue.serverTimestamp(),
                                          'imageData': tool['imageData'],
                                        });
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Request submitted')),
                                        );
                                        _descriptionController.clear();
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10).r,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10).r,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Request',
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          // My Tools Tab (Accepted Tools)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tool_requests')
                .where('employeeId', isEqualTo: currentUserId)
                .where('status', isEqualTo: 'accepted')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No accepted tools'));
              }
              final acceptedTools = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.all(12).r,
                itemCount: acceptedTools.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final request =
                      acceptedTools[index].data() as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffCCE4FF),
                        borderRadius: BorderRadius.circular(10).r),
                    margin: const EdgeInsets.only(bottom: 16).r,
                    child: Padding(
                      padding: const EdgeInsets.all(12).r,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8).r,
                            child: Image.memory(
                              base64Decode(request['imageData'] ?? ''),
                              height: 60.h,
                              width: 60.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['toolName'] ?? 'N/A',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 2.5.h),
                                Text("ID: ${request['toolId'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                Text("Type: ${request['type'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                Text(
                                    "Requested Date: ${request['created_at']?.toDate().toLocal().toString().split(' ')[0] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                Text(
                                    "Status: ${request['status'] ?? 'accepted'}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: _getStatusColor(
                                            request['status'] ?? 'accepted'))),
                                SizedBox(height: 2.5.h),
                                Text(
                                    "Description: ${request['description'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Requested Tools Tab (Pending and Rejected Tools)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tool_requests')
                .where('employeeId', isEqualTo: currentUserId)
                .where('status', whereIn: ['pending', 'rejected']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('No pending or rejected requests'));
              }
              final requestedTools = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.all(12).r,
                itemCount: requestedTools.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final request =
                      requestedTools[index].data() as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                        color: const Color(0xffCCE4FF),
                        borderRadius: BorderRadius.circular(10).r),
                    margin: const EdgeInsets.only(bottom: 16).r,
                    child: Padding(
                      padding: const EdgeInsets.all(12).r,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8).r,
                            child: Image.memory(
                              base64Decode(request['imageData'] ?? ''),
                              height: 60.h,
                              width: 60.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['toolName'] ?? 'N/A',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 2.5.h),
                                Text("ID: ${request['toolId'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                Text("Type: ${request['type'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                Text(
                                    "Requested Date: ${request['created_at']?.toDate().toLocal().toString().split(' ')[0] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                Text(
                                    "Status: ${request['status'] ?? 'pending'}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: _getStatusColor(
                                            request['status'] ?? 'pending'))),
                                SizedBox(height: 2.5.h),
                                Text(
                                    "Description: ${request['description'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 2.5.h),
                                if (request['status'] == 'rejected' &&
                                    request['rejectionReason'] != null)
                                  Text(
                                      "Rejection Reason: ${request['rejectionReason']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTab = null; // Deselect if already selected
          } else {
            selectedTab = title; // Select new tab
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16).r,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.black : Colors.white,
        ),
        child: Center(
          child: Text(title,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
