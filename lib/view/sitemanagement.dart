import 'package:construction_app/view/add%20_site.dart';
import 'package:flutter/material.dart';

class ViewSitesPage extends StatelessWidget {
  const ViewSitesPage({super.key});

  // Example list of site data
  final List<Map<String, String>> siteData = const [
    {
      'name': 'Site A',
      'place': 'Bangalore',
      'latitude': '12.9716',
      'longitude': '77.5946',
    },
    {
      'name': 'Site B',
      'place': 'Chennai',
      'latitude': '13.0827',
      'longitude': '80.2707',
    },
    {
      'name': 'Site C',
      'place': 'Kochi',
      'latitude': '9.9312',
      'longitude': '76.2673',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("View Sites"),
            Spacer(),
               _buildAddButton(context, Icons.person_add, "Add Site", () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => AddSitePage(),
                  //     ));
                }),
          ],
        ),
        backgroundColor: const Color(0xff2B55C7),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: siteData.length,
        itemBuilder: (context, index) {
          final site = siteData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2B55C7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("📍 Place: ${site['place']}"),
                  Text("📌 Latitude: ${site['latitude']}"),
                  Text("📌 Longitude: ${site['longitude']}"),
                ],
              ),
            ),
          );
        },
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
