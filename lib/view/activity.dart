
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  final List<Map<String, dynamic>> activityData = const [
    {
      'date': 'August 07,2024',
      'checkIn': '10:00 am',
      'checkInStatus': 'late',
      'checkOut': '5:00 pm',
      'checkOutStatus': 'on-time',
    },
    {
      'date': 'August 05,2024',
      'checkIn': '9:00 am',
      'checkInStatus': 'on-time',
      'checkOut': '6:00 pm',
      'checkOutStatus': 'overtime',
    },
    {
      'date': 'August 04,2024',
      'checkIn': '9:10 am',
      'checkInStatus': 'on-time',
      'checkOut': '5:00 pm',
      'checkOutStatus': 'on-time',
    },
    {
      'date': 'August 03,2024',
      'checkIn': '9:00 am',
      'checkInStatus': 'on-time',
      'checkOut': '4:45 pm',
      'checkOutStatus': 'early',
    },
    {
      'date': 'August 02,2024',
      'checkIn': '9:30 am',
      'checkInStatus': 'late',
      'checkOut': '4:55 pm',
      'checkOutStatus': 'on-time',
    },
    {
      'date': 'August 01,2024',
      'checkIn': '00:00 am',
      'checkInStatus': 'no record',
      'checkOut': '00:00 pm',
      'checkOutStatus': 'no record',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "ACTIVITY",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0A2342),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: activityData.length,
                  itemBuilder: (context, index) {
                    final data = activityData[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['date'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xff0A2342),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.login, color: Colors.blue),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  Text(
                                    data['checkIn'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xff0A2342),
                                    ),
                                  ),
                                  Text(
                                data['checkInStatus'],
                                style: TextStyle(
                                  fontSize: 13,
                                  // color:
                                      // _getStatusColor(data['checkInStatus']),
                                ),
                              ),

                                ],
                              ),
                              const SizedBox(width: 8),
                              
                              const Spacer(),
                              const Icon(Icons.logout, color: Colors.blue),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  Text(
                                    data['checkOut'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xff0A2342),
                                    ),
                                  ),
                                   Text(
                                data['checkOutStatus'],
                                style: TextStyle(
                                  fontSize: 13,
                                  // color:
                                      // _getStatusColor(data['checkOutStatus']),
                                ),
                              ),
                                ],
                              ),
                              const SizedBox(width: 8),
                             
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
