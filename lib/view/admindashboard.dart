import 'package:construction_app/view/add%20_site.dart';
import 'package:construction_app/view/add_tools.dart';
import 'package:construction_app/view/addemployee.dart';
import 'package:construction_app/view/employeelist.dart';
import 'package:construction_app/view/sitemanagement.dart';
import 'package:construction_app/view/toolmanagement.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardPage(),
  ));
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color(0xff1A5293),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Overview of today's activities",
            //   style: TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xff1A5293),
            //   ),
            // ),
            const SizedBox(height: 24),

            // Add buttons in a row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAddButton(context, Icons.person_add, "Add Employee", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEmployee(),
                      ));
                }),
                _buildAddButton(context, Icons.construction, "Add Tools", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddToolPage(),
                      ));
                }),
                _buildAddButton(context, Icons.home_work, "Add Site", () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => AddSitePage(),
                  //     ));
                }),
              ],
            ),
            const SizedBox(height: 36),

            // Clickable containers
            _buildClickableContainer(context, "Employees details ", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeManagementPage(),
                  ));
            }),
            const SizedBox(height: 16),
            _buildClickableContainer(context, "Active  Tools", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToolManagementPage(),
                  ));
            }),
            const SizedBox(height: 16),
            _buildClickableContainer(context, "View Sites", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSitesPage(),
                  ));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, // onTap as a parameter
  ) {
    return Column(
      children: [
        Material(
          elevation: 6,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.grey.withOpacity(0.4),
          child: InkWell(
            onTap: onTap, // use the passed onTap
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xff3F72AF), size: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
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
      borderRadius: BorderRadius.circular(12),
      splashColor: const Color(0xff3F72AF).withOpacity(0.2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff1A5293), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1A5293),
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Color(0xff1A5293))
          ],
        ),
      ),
    );
  }
}
