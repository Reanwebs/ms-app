
import 'package:construction_app/view/activity.dart';
import 'package:construction_app/view/attendancemarkpage.dart';
import 'package:construction_app/view/my%20profile.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmployeeHomePage(),
  ));
}

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    Center(child: Text("Time Page")),
    ActivityPage(),
    HomeContentPage(),
    MainTabPage(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
    );
  }
}

// ================= Home Content Separated for Clarity ================= //
class HomeContentPage extends StatefulWidget {
  @override
  State<HomeContentPage> createState() => _HomeContentPageState();

  static Widget _reportCard(
      String title, String time, String status, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 210, 232, 248),
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 6),
            Text(time,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(status, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  static Widget _progressCard(String title, int value, double percent) {
    final dataMap = <String, double>{
      "Blue": 30,
      "Dark Blue": 20,
      "Light Blue": 50,
    };

    final colorList = <Color>[
      const Color(0xFF004E98), // Dark Blue
      const Color(0xFF6FA8DC), // Light Blue
      const Color(0xFF9ECFFF), // Extra light
    ];
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue.shade100),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartRadius: 50,
                  colorList: colorList,
                  chartType: ChartType.disc,
                  ringStrokeWidth: 0,
                  legendOptions: const LegendOptions(showLegends: false),
                  chartValuesOptions:
                      const ChartValuesOptions(showChartValues: false),
                ),
                Column(
                  children: [
                    Text(
                      "$value",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Days",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ]),
              const SizedBox(width: 12),
              const SizedBox(height: 8),
            ])));
  }

  static Widget _activityTile(String date, String checkIn, String statusIn,
      String checkOut, String statusOut) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff2B55C7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Check-in :\n$checkIn\n$statusIn",
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xff2B55C7))),
              Text("Check-out :\n$checkOut\n$statusOut",
                  style: const TextStyle(fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}

class _HomeContentPageState extends State<HomeContentPage> {
  int selectedIndex = 3;

  final List<String> days = ['04', '05', '06', '07', '08', '09', '10'];

  final List<String> names = ['Fri', 'Sat', 'Sun', 'Mon', 'Tues', 'Wed', 'Thu'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCwuhGpkKbtJN5VicvmTyjoGhSUZFzEs1yOVcjr7UZy0EmpXb899UIxuA&s'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bartholomew',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('UI/UX Designer',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.notifications_none)
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (_, index) {
                  final isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF112D4E)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(
                        //     color: const Color(0xFF112D4E).withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            days[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            names[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text("Todays Report",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3F72AF))),
            const SizedBox(height: 10),
            Row(
              children: [
                HomeContentPage._reportCard(
                  "Check-In",
                  "10:00 am",
                  "late",
                  Icons.login,
                ),
                const SizedBox(width: 10),
                HomeContentPage._reportCard(
                    "Check-Out", "5:00 pm", "on-time", Icons.logout),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                HomeContentPage._progressCard("Present", 148, 0.74),
                const SizedBox(width: 10),
                HomeContentPage._progressCard("Total Working\nDays", 200, 1.0),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xff2B55C7)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: Text("Monthly Report",
                    style: TextStyle(color: Color(0xff3F72AF))),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Activity",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3F72AF))),
                Text("View All", style: TextStyle(color: Color(0xff3F72AF))),
              ],
            ),
            HomeContentPage._activityTile(
                "August 05, 2024", "9:00 am", "on-time", "6:00 pm", "overtime"),
            HomeContentPage._activityTile(
                "August 04, 2024", "9:00 am", "on-time", "6:00 pm", "overtime"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
