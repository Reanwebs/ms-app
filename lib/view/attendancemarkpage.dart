// import 'package:flutter/material.dart';
// import 'package:slide_to_act/slide_to_act.dart';

// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MarkAttendancePage(),
//   ));
// }

// class MarkAttendancePage extends StatelessWidget {
//   const MarkAttendancePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<SlideActionState> slideKey = GlobalKey();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 24),
//               const Text(
//                 'MARK',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff0A2342),
//                 ),
//               ),
//               const Text(
//                 'ATTENDENCE',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff0A2342),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Todays Attendence",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xff0A57CF),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _attendanceCard(
//                 icon: Icons.login,
//                 title: "Check-In",
//                 time: "00:00 am",
//               ),
//               const SizedBox(height: 16),
//               _attendanceCard(
//                 icon: Icons.logout,
//                 title: "Check-Out",
//                 time: "00:00 pm",
//               ),
//               const SizedBox(height: 32),

//               // Swipe to Check-In
//               SlideAction(
//                 key: slideKey,
//                 borderRadius: 30,
//                 elevation: 0,
//                 outerColor: const Color(0xffC5FFD9),
//                 innerColor: Colors.white,
//                 sliderButtonIcon: const Icon(Icons.arrow_forward, color: Color(0xff55C099)),
//                 text: "Swipe to Check In",
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xff0A2342),
//                 ),
//                 onSubmit: () {
//                   slideKey.currentState?.reset();

//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text('Location Access Required'),
//                       content: const Text('Location access is required to perform check-in.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             // TODO: Add location permission logic here
//                           },
//                           child: const Text('Allow'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _attendanceCard({
//     required IconData icon,
//     required String title,
//     required String time,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       decoration: BoxDecoration(
//         color: const Color(0xffCCE4FF),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xff94C0F1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.white, size: 22),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             time,
//             style: const TextStyle(
//               fontSize: 22,
//               color: Color(0xff0A2342),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Text(
//             "no record",
//             style: TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
// Import statements

import 'package:construction_app/view/toolpage.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainTabPage(),
  ));
}

// -------------------- Main Tab Page --------------------
class MainTabPage extends StatelessWidget {
  const MainTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A5293),
          title: const Text('Attendance App', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Mark Attendance'),
              Tab(text: 'Tools'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MarkAttendancePage(),
            ToolsLogPage(),
          ],
        ),
      ),
    );
  }
}

// -------------------- Mark Attendance Page --------------------
class MarkAttendancePage extends StatelessWidget {
  const MarkAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionState> slideKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text('MARK', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff0A2342))),
              const Text('ATTENDANCE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff0A2342))),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Today's Attendance", style: TextStyle(fontSize: 16, color: Color(0xff0A57CF), fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),
              _attendanceCard(icon: Icons.login, title: "Check-In", time: "00:00 am"),
              const SizedBox(height: 16),
              _attendanceCard(icon: Icons.logout, title: "Check-Out", time: "00:00 pm"),
              const SizedBox(height: 32),
              SlideAction(
                key: slideKey,
                borderRadius: 30,
                elevation: 0,
                outerColor: const Color(0xffC5FFD9),
                innerColor: Colors.white,
                sliderButtonIcon: const Icon(Icons.arrow_forward, color: Color(0xff55C099)),
                text: "Swipe to Check In",
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff0A2342)),
                onSubmit: () async {
                  await Future.delayed(const Duration(seconds: 1));
                     showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Location Access Required'),
                      content: const Text('Location access is required to perform check-in.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Add location permission logic here
                          },
                          child: const Text('Allow'),
                        ),
                      ],
                    ),
                  );
                  slideKey.currentState?.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _attendanceCard({required IconData icon, required String title, required String time}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xffCCE4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff94C0F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
            ],
          ),
          const SizedBox(height: 12),
          Text(time, style: const TextStyle(fontSize: 22, color: Color(0xff0A2342), fontWeight: FontWeight.bold)),
          const Text("no record", style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
