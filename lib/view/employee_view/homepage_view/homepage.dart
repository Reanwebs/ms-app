import 'package:construction_app/view/employee_view/homepage_view/widget/homepageui.dart';
import 'package:construction_app/view/employee_view/profile_view/my%20profile.dart';
import 'package:construction_app/view/employee_view/tools_view/tool_list_page.dart';
import 'package:flutter/material.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  int _selectedIndex = 1;
  void setPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const EmployeeToolsPage(),
      const HomeContentPage(),
      const ProfileScreen()
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.black),
        onTap: setPage,
        items: const [
          BottomNavigationBarItem(
              icon:
                  Icon(Icons.home_repair_service_rounded, color: Colors.black),
              label: 'Tools'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              label: 'Profile'),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }
}
