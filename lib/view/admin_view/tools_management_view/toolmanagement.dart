import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ToolManagementPage extends StatefulWidget {
  const ToolManagementPage({super.key});

  @override
  State<ToolManagementPage> createState() => _ToolManagementPageState();
}

class _ToolManagementPageState extends State<ToolManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Text(
          'Tool Management',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10.r),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: "Tools Inventory"),
            Tab(text: "Tool Log"),
            Tab(text: "Requested Tools"),
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
        children: const [
          ToolInventoryTab(),
          ToolLogTab(),
          RequestedToolsTab(),
        ],
      ),
    );
  }
}

// ---------------------- Tools Inventory Tab ----------------------
class ToolInventoryTab extends StatefulWidget {
  const ToolInventoryTab({super.key});

  @override
  State<ToolInventoryTab> createState() => _ToolInventoryTabState();
}

class _ToolInventoryTabState extends State<ToolInventoryTab> {
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'checked out':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _deleteTool(String toolId, BuildContext context) async {
    await FirebaseFirestore.instance.collection('tools').doc(toolId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tool deleted')),
    );
  }

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tools').snapshots(),
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

        final searchQuery = _searchController.text.trim().toLowerCase();
        final tools = snapshot.data!.docs.where((doc) {
          final tool = doc.data() as Map<String, dynamic>;
          final toolName = (tool['name'] ?? '').toString().toLowerCase();
          return searchQuery.isEmpty || toolName.contains(searchQuery);
        }).toList();
        return Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20).r,
              child: CommonWidgets().commonTextfield(
                hintText: 'Search Tool/Material',
                textController: _searchController,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onchanged: (p0) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), () {
                    setState(() {});
                  });
                },
              ),
            ),
            Expanded(
              child: tools.isEmpty
                  ? const Center(
                      child: Text('No matching Tools/Material found'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)
                          .r,
                      itemCount: tools.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final tool =
                            tools[index].data() as Map<String, dynamic>;
                        final toolId = tools[index].id;
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
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error,
                                          color: Colors.red);
                                    },
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
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 2.5.h),
                                      Text(
                                        "Tool ID: ${tool['code'] ?? 'N/A'}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 2.5.h),
                                      Text("Type: ${tool['type'] ?? 'N/A'}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(height: 2.5.h),
                                      Text(
                                        "Count: ${tool['count'] ?? 0}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ).r,
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                                  tool['status'] ?? 'Unknown')
                                              .withOpacity(0.1),
                                          border: Border.all(
                                              color: _getStatusColor(
                                                  tool['status'] ?? 'Unknown')),
                                          borderRadius:
                                              BorderRadius.circular(20).r,
                                        ),
                                        child: Text(
                                          tool['status'] ?? 'Unknown',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: _getStatusColor(
                                                tool['status'] ?? 'Unknown'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteTool(toolId, context),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------- Tool Log Tab ----------------------
class ToolLogTab extends StatelessWidget {
  const ToolLogTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tool_logs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No tool logs available'));
        }

        final logs = snapshot.data!.docs;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
          itemCount: logs.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final log = logs[index].data() as Map<String, dynamic>;
            return Container(
              decoration: BoxDecoration(
                  color: const Color(0xffCCE4FF),
                  borderRadius: BorderRadius.circular(10).r),
              margin: const EdgeInsets.only(bottom: 16).r,
              child: Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tool Name: ${log['toolName'] ?? 'N/A'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    SizedBox(height: 5.h),
                    Text("Type: ${log['type'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 2.5.h),
                    Text("Checked out by: ${log['employeeName'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 2.5.h),
                    Text(
                        "Check-out Time: ${log['checkOutTime']?.toDate().toLocal() ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 2.5.h),
                    Text(
                        "Check-in Time: ${log['checkInTime']?.toDate().toLocal() ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 2.5.h),
                    Text("Date: ${log['date'] ?? 'N/A'}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ---------------------- Requested Tools Tab ----------------------
class RequestedToolsTab extends StatelessWidget {
  const RequestedToolsTab({super.key});

  Future<void> updateStatus(String docId, String newStatus,
      BuildContext context, Map<String, dynamic> request) async {
    if (newStatus == 'accepted') {
      // Validate quantity
      final toolDoc = await FirebaseFirestore.instance
          .collection('tools')
          .where('code', isEqualTo: request['toolId'])
          .get();
      if (toolDoc.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tool not found')),
        );
        return;
      }
      final tool = toolDoc.docs.first.data();
      final toolId = toolDoc.docs.first.id;
      final availableCount = tool['count'] ?? 0;
      final requestedQuantity = request['quantity'] ?? 1;

      if (requestedQuantity > availableCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Requested quantity exceeds available count')),
        );
        return;
      }

      // Update tool status and count
      await FirebaseFirestore.instance.collection('tools').doc(toolId).update({
        'status': 'checked out',
        'count': availableCount - requestedQuantity,
      });

      // Create tool log
      final employeeDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(request['employeeId'])
          .get();
      final employeeName =
          employeeDoc.data()?['username'] ?? 'Unknown Employee';
      final today = DateTime.now();
      final dateStr =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      await FirebaseFirestore.instance.collection('tool_logs').add({
        'toolName': request['toolName'],
        'toolId': request['toolId'],
        'employeeId': request['employeeId'],
        'employeeName': employeeName,
        'checkOutTime': FieldValue.serverTimestamp(),
        'checkInTime': null,
        'date': dateStr,
      });

      // Update request status
      await FirebaseFirestore.instance
          .collection('tool_requests')
          .doc(docId)
          .update({'status': 'accepted'});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tool request accepted')),
      );
    } else if (newStatus == 'rejected') {
      _showRejectionReasonDialog(context, docId);
    }
  }

  void _showRejectionReasonDialog(BuildContext context, String docId) {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reason for Rejection'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Enter reason'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('tool_requests')
                  .doc(docId)
                  .update({
                'status': 'rejected',
                'rejectionReason': reasonController.text,
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rejection reason submitted')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<String> _getEmployeeName(String employeeId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(employeeId)
        .get();
    return userDoc.data()?['username'] ?? 'Unknown Employee';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('tool_requests').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No tool requests'));
        }

        final requestedTools = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
          itemCount: requestedTools.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final doc = requestedTools[index];
            final data = doc.data() as Map<String, dynamic>;
            return FutureBuilder<String>(
              future: _getEmployeeName(data['employeeId']),
              builder: (context, employeeSnapshot) {
                if (employeeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final employeeName = employeeSnapshot.data ?? 'Loading...';
                return Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffCCE4FF),
                      borderRadius: BorderRadius.circular(10).r),
                  margin: const EdgeInsets.only(bottom: 16).r,
                  child: Padding(
                    padding: const EdgeInsets.all(12).r,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8).r,
                          child: Image.memory(
                            base64Decode(data['imageData'] ?? ''),
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
                              Text(data['toolName'] ?? 'N/A',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp)),
                              SizedBox(height: 2.5.h),
                              Text("ID: ${data['toolId'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 2.5.h),
                              Text("Type: ${data['type'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 2.5.h),
                              Text("Quantity: ${data['quantity'] ?? 1}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 2.5.h),
                              Text(
                                  "Description: ${data['description'] ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 2.5.h),
                              Text("Requested by: $employeeName",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 2.5.h),
                              Text("Status: ${data['status'] ?? 'pending'}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(height: 2.5.h),
                              if (data['status'] == 'rejected' &&
                                  data['rejectionReason'] != null)
                                Text(
                                    "Rejection Reason: ${data['rejectionReason']}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    )),
                            ],
                          ),
                        ),
                        if (data['status'] == 'pending')
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () => updateStatus(
                                    doc.id, 'accepted', context, data),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: const Size(80, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8).r,
                                  ),
                                ),
                                child: const Text("Accept",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white)),
                              ),
                              SizedBox(height: 8.h),
                              ElevatedButton(
                                onPressed: () => updateStatus(
                                    doc.id, 'rejected', context, data),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: const Size(80, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8).r,
                                  ),
                                ),
                                child: const Text("Reject",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.white)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
