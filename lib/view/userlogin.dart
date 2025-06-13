
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/view/forgot_password.dart';
import 'package:construction_app/view/homepage.dart';
import 'package:construction_app/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = true;
  final TextEditingController _usernameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
@override
void dispose() {
  _usernameController.dispose();
  _passwordController.dispose();
  super.dispose();
}


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
  controller: _usernameController,
  decoration: InputDecoration(
    prefixIcon: const Icon(Icons.person, color: Colors.grey),
    hintText: 'Username',
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
),

              const SizedBox(height: 16),
              TextField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>ForgotPasswordScreen() ,));
                    },
                    child: const Text("Forgot password",style: TextStyle(color: Color(0xff012970)),),
                  ),
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
                 onPressed: () async {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter username and password")),
    );
    return;
  }

  try {
    // 1. Get user's email from Firestore using username
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username not found")),
      );
      return;
    }

    String email = userSnapshot.docs.first['email'];

    // 2. Sign in using email and password
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 3. Navigate to homepage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EmployeeHomePage()),
    );
  } on FirebaseAuthException catch (e) {
    String message = "Login failed";
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password provided.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
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
