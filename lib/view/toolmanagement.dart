import 'package:construction_app/view/add_tools.dart';
import 'package:flutter/material.dart';

class ToolManagementPage extends StatefulWidget {
  const ToolManagementPage({super.key});

  @override
  State<ToolManagementPage> createState() => _ToolManagementPageState();
}

class _ToolManagementPageState extends State<ToolManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // fixed to 3 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Tool Management"),
            Spacer(),
               _buildAddButton(context, Icons.person_add, "Add Tools", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddToolPage(),
                      ));
                }),
            
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff1A5293),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Tools Inventory"),
            Tab(text: "Tool Log"),
            Tab(text: "Requested Tools"),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ToolInventoryTab(),
          ToolLogTab(),
          RequestedToolsTab(),
        ],
      ),
    );
    
  }
   Widget _buildAddButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, // onTap as a parameter
  ) {
    return Column(
      children: [
        Material(
          elevation: 6,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          shadowColor: Colors.grey.withOpacity(0.4),
          child: InkWell(
            onTap: onTap, // use the passed onTap
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xff3F72AF), size: 20),
            ),
          ),
        ),
      
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ---------------------- Tools Inventory Tab ----------------------
class ToolInventoryTab extends StatelessWidget {
  const ToolInventoryTab({super.key});

  final List<Map<String, dynamic>> tools = const [
    {
      'name': 'Drill Machine',
      'image': 'https://via.placeholder.com/150',
      'id': 'TL-001',
      'status': 'Available',
    },
    {
      'name': 'Hammer',
      'image': 'https://via.placeholder.com/150',
      'id': 'TL-002',
      'status': 'Checked Out',
    },
    {
      'name': 'Welding Torch',
      'image': 'https://via.placeholder.com/150',
      'id': 'TL-003',
      'status': 'Available',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'checked out':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0x4D4E93EF),
            border: Border.all(color: const Color(0xff2B55C7), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tool['image'],
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A5293),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ID: ${tool['id']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(tool['status']).withOpacity(0.1),
                          border: Border.all(color: _getStatusColor(tool['status'])),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tool['status'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(tool['status']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------- Tool Log Tab ----------------------
class ToolLogTab extends StatelessWidget {
  const ToolLogTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Tool Name: Drill Machine", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("Checked out by: Ramesh Kumar"),
                SizedBox(height: 4),
                Text("Check-out Time: 10:30 AM"),
                SizedBox(height: 4),
                Text("Check-in Time: 4:00 PM"),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------- Requested Tools Tab ----------------------
class RequestedToolsTab extends StatelessWidget {
  const RequestedToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> requestedTools = [
      {
        "name": "Electric Drill",
        "image": "https://img.icons8.com/fluency/96/drill.png",
        "id": "TOOL-REQ-001"
      },
      {
        "name": "Welding Torch",
        "image": "https://img.icons8.com/fluency/96/welding.png",
        "id": "TOOL-REQ-002"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: requestedTools.length,
      itemBuilder: (context, index) {
        final tool = requestedTools[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xff2B55C7), width: 1.2),
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0x4F4E93EF),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  tool['image']!,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tool['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text("ID: ${tool['id']}", style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Accept logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Accept", style: TextStyle(fontSize: 13,color: Colors.white)),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Decline logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Decline", style: TextStyle(fontSize: 13,color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
