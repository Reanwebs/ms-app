import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:construction_app/view/set_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddEmployee(),
  ));
}

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _onNextPressed() async {
  if (_formKey.currentState!.validate()) {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String mobile = _mobileController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get user ID
      String uid = userCredential.user!.uid;

      // Save additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'mobile': mobile,
        'created_at': Timestamp.now(),
      });

      // Navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetPasswordscreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(),
                const SizedBox(height: 10),
                Center(
                  child: Image.network(
                    'https://img.freepik.com/free-vector/devices-concept-illustration_114360-90.jpg',
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Enter Employee Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Username (required)
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration("Username", Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email (optional for now)
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email", Icons.email),
                ),
                const SizedBox(height: 16),

                // Mobile (required)
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration("+91 | Mobile Number", Icons.phone),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty || value.length < 10) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password (required)
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration("Password", Icons.lock),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1A5293),
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
    
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
      ),
    );
  }
}
