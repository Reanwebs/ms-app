
import 'package:construction_app/view/admin_login.dart';
import 'package:construction_app/view/addemployee.dart';
import 'package:construction_app/view/login.dart';
import 'package:construction_app/view/userlogin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SelectRoleScreen(),
  ));
}

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  String? selectedRole;

 void _onNext() {
  if (selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a role")),
    );
  } else {
    if (selectedRole == 'Employee') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeBackScreen()),
      );
    } else if (selectedRole == 'Employer') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Adminlogin()),
      );
    }
    print("Selected role: $selectedRole");
  }
}


  Widget _buildRoleButton(String role) {
    bool isSelected = selectedRole == role;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 7),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedRole = role;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Color(0xffF0F0F1),
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: 0,
          side: const BorderSide(color: Color(0xff2B55C7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Text(
          role,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              const SizedBox(height: 10),
              Image.network(
                'https://img.freepik.com/free-vector/team-concept-illustration_114360-658.jpg',
                height: MediaQuery.of(context).size.height / 3,
              ),
              const SizedBox(height: 30),
              const Text(
                'New Here ?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please select your role',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildRoleButton('Employee'),
              const SizedBox(height: 16),
              _buildRoleButton('Employer'),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ? "),
                  GestureDetector(
                    onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginApp(),));
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                // width: double.infinity,
                width: MediaQuery.of(context).size.width / 2.5,
                height: 40,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1A5293),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
