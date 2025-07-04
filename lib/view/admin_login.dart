
import 'package:construction_app/view/admindashboard.dart';
import 'package:construction_app/view/forgot_password.dart';
import 'package:construction_app/view/homepage.dart';
import 'package:construction_app/widgets/appbar.dart';
import 'package:flutter/material.dart';



class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<Adminlogin> createState() => _AdminloginState();
}

class _AdminloginState extends State<Adminlogin> {
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
    onBack: () => Navigator.pop(context),
  ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: IconButton(
              //     icon: const Icon(Icons.arrow_back),
              //     onPressed: () {},
              //   ),
              // ),
              const SizedBox(height: 10),
              Image.network(
                'https://img.freepik.com/free-vector/login-concept-illustration_114360-757.jpg?semt=ais_hybrid&w=740',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to MS App !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to your account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person,color: Colors.grey),
                  hintText: 'admin-Username',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock,color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),

                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: Color(0xff012970),
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text("Remember me"),
                  const Spacer(),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) =>ForgotPasswordScreen() ,));
                  //   },
                  //   child: const Text("Forgot password",style: TextStyle(color: Color(0xff012970)),),
                  // ),
                ],
              ),
              
              
              const SizedBox(height: 10),
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Text("Don’t have an account ? "),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: const Text(
                  //     "Sign Up",
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1A5293),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage(),));
                  },
                  child: const Text("Log In", style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
          
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
