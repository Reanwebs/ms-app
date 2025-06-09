
import 'package:construction_app/view/tooldetails.dart';
import 'package:flutter/material.dart';

class ToolsLogPage extends StatelessWidget {
  const ToolsLogPage({super.key});

  final List<Map<String, dynamic>> tools = const [
    {
      'id': 'TL0021',
      'name': 'Trowel',
      'image': 'https://img.freepik.com/free-photo/construction-hammer-indoors-still-life_23-2150563177.jpg?ga=GA1.1.1381786194.1735365615&semt=ais_items_boosted&w=740',
      'status': 'Available'
    },
    {
      'id': 'TL0031',
      'name': 'Trowel',
      'image': 'https://img.freepik.com/free-photo/top-view-steel-hammer-with-other-construction-elements-tools_23-2150576396.jpg?ga=GA1.1.1381786194.1735365615&semt=ais_items_boosted&w=740',
      'status': 'On use'
    },
    {
      'id': 'TL0041',
      'name': 'Trowel',
      'image': 'assets/images/drill.png',
      'status': 'Available'
    },
    {
      'id': 'TL0021',
      'name': 'Trowel',
      'image': 'assets/images/wheelbarrow_yellow.png',
      'status': 'Available'
    },
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'on use':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

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
              const Text(
                'Tools Log',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0A2342),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Available Tools',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff0A57CF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: tools.length,
                  itemBuilder: (context, index) {
                    final tool = tools[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ToolDetailPage(),));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffCCE4FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              tool['image'],
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tool['id'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xff0A2342),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        tool['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff0A2342),
                                        ),
                                      ),Spacer(),
                                         Text(
                              tool['status'],
                              style: TextStyle(
                                color: _getStatusColor(tool['status']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      
                                    ],
                                  ),
                                ],
                              ),
                            ),
                         
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.purple)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
