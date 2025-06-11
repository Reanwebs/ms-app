import 'package:flutter/material.dart';

class CheckInSuccessPage extends StatelessWidget {
  const CheckInSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Success Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_box, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Check-in Successful',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0A2342),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // ⭕ Circular Duration Display
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent.shade100,
                      width: 12,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '00h 01m',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  "Date:April 19 2025",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 4, 3, 60), fontSize: 20),
                ),

                Text(
                  "Location:[12.9345, 77.6190]",
                  style: TextStyle(color: const Color.fromARGB(255, 4, 3, 60)),
                ),
                const SizedBox(height: 30),

                Text(
                  "Your check-in has been marked",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),

                const SizedBox(height: 60),

                // 🔵 Go to Dashboard Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0A57CF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Go to Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
