import 'package:construction_app/view/addemployee.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmployeeManagementPage(),
  ));
}

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  final List<Map<String, String>> employeeData = const [
    {
      'name': 'John Doe',
      'role': 'Engineer',
      'status': 'Active',
      'site': 'Site A',
    },
    {
      'name': 'Jane Smith',
      'role': 'Supervisor',
      'status': 'On Leave',
      'site': 'Site B',
    },
    {
      'name': 'Michael Johnson',
      'role': 'Worker',
      'status': 'Active',
      'site': 'Site A',
    },
    {
      'name': 'Emily Brown',
      'role': 'Manager',
      'status': 'Active',
      'site': 'Site C',
    },
    {
      'name': 'Chris Evans',
      'role': 'Electrician',
      'status': 'Inactive',
      'site': 'Site D',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xff1A5293),
      //   title: const Text('Employee Management'),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Employee List",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A5293),
                  ),
                ),
                Spacer(),
                 _buildAddButton(context, Icons.person_add, "Add Employee", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEmployee(),
                      ));
                }),

              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: employeeData.length,
                itemBuilder: (context, index) {
                  final employee = employeeData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x4D4E93EF), // #4E93EF63 with 30% opacity
                      border: Border.all(color: Color(0xff2B55C7), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Name", employee['name']!),
                        const SizedBox(height: 6),
                        _infoRow("Role", employee['role']!),
                        const SizedBox(height: 6),
                        _infoRow("Status", employee['status']!),
                        const SizedBox(height: 6),
                        _infoRow("Site", employee['site']!),
                      ],
                    ),
                  );
                },
              ),
            ),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xff3F72AF), size: 20),
            ),
          ),
        ),
      
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
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
