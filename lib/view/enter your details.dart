import 'package:construction_app/view/set_password.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EnterDetailsScreen(),
  ));
}

class EnterDetailsScreen extends StatelessWidget {
  const EnterDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                  "Enter Your Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const _CustomInputField(
                icon: Icons.person,
                hintText: "Username",
              ),
              const SizedBox(height: 16),
              const _CustomInputField(
                icon: Icons.email,
                hintText: "Email",
              ),
              const SizedBox(height: 16),
              const _CustomInputField(
                icon: Icons.phone,
                hintText: "+91 | Mobile Number",
              ),
              const SizedBox(height: 16),
              const _CustomInputField(
                icon: Icons.password,
                hintText: "Company / Access code",
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("or sign up with"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(
                    imagePath: 'assets/icons/google_icon.png',
                  ),
                  const SizedBox(width: 24),
                  _SocialIcon(imagePath: 'assets/icons/facebook_icon.png'),
                  const SizedBox(width: 24),
                  _SocialIcon(imagePath: 'assets/icons/twitter_icon.png'),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  // width: double.infinity,
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetPasswordscreen(),
                          ));
                    },
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final EdgeInsetsGeometry? contentPadding;

  const _CustomInputField({
    required this.icon,
    required this.hintText,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 16, // Increased vertical padding
              horizontal: 16,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade300, // More visible border color
            width: 1.0, // Explicit border width
          ),
        ),
        enabledBorder: OutlineInputBorder(
          // Border when not focused
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          // Border when focused
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blue.shade400, // Different color when focused
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String imagePath;

  const _SocialIcon({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: Image.asset(
        imagePath,
        height: 25,
      ),
    );
  }
}
