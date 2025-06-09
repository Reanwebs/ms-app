
import 'package:construction_app/view/sign_up.dart';
import 'package:construction_app/view/userlogin.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(const LoginApp());
// }

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In",style: TextStyle(color: Color(0xff1A5293)),),
        actions: [IconButton(icon: const Icon(Icons.close), onPressed: () {})],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "Let’s Dive Into Your\n Account",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Color(0xff112D4E)),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "If you already have an account, we’ll log you in.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            LoginButton(
              icon: Icons.email,
              text: "Login with Email",
              
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            LoginButton(
              icon: Icons.person,
              text: "Login with Username",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>WelcomeBackScreen() ,));
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: const <Widget>[
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("or continue with"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            SocialLoginButton(
              logoPath:
                  'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
              text: "Login with Google",
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            SocialLoginButton(
              logoPath:
                  'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
              text: "Login with Facebook",
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            SocialLoginButton(
              logoPath:
                  'https://about.x.com/content/dam/about-twitter/x/brand-toolkit/logo-black.png.twimg.1920.png',
              text: "Login with X",
              onPressed: () {},
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "New here ? Let’s sign you up.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff1A5293),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>SelectRoleScreen() ,));
            
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Color(0xff3F72AF))),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String logoPath;
  final String text;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.logoPath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(logoPath, height: 24, width: 24),
          const SizedBox(width: 20),
          Text(text, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
