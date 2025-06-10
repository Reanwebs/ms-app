import 'package:flutter/material.dart';

class ToolDetailPage extends StatelessWidget {
  const ToolDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Tool Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2342),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/wheelbarrow_yellow.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 8),
            const Text(
              'TL0021',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2342),
              ),
            ),
            const Text(
              'Trowel',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(width: 200,
            height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0A57CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                ),
                onPressed: () {
                  // Handle request
                },
                child: const Text(
                  'Request Tool',
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _infoCard(title: "Check-Out", time: "00:00 am", icon: Icons.logout),
            const SizedBox(height: 12),
            _infoCard(title: "Check-In", time: "00:00 am", icon: Icons.login),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      {required String title, required String time, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffCCE4FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xff2B55C7)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A2342))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
