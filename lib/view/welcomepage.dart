import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: WelcomeScreen(username: 'Salmun'),
  ));
}

class WelcomeScreen extends StatelessWidget {
  final String username;

  const WelcomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Image.network(
              'https://img.freepik.com/free-vector/welcome-aboard-concept-illustration_114360-8898.jpg?semt=ais_hybrid&w=740',
              fit: BoxFit.cover,
            ),
          ),
          // const SizedBox(height: 20),
          Text(
            'Welcome Salmun',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "We're excited to have you.\nWith this app, you'll easily manage your daily check-ins, access essential tools, and stay connected right from your worksite.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 40),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1A5293),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // Navigate to profile settings screen
                },
                child: const Text(
                  'Profile Settings',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
