import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToolDetailPage extends StatefulWidget {
  final String toolId;
  final String toolName;
  final String? imageUrl;

  const ToolDetailPage({
    super.key,
    required this.toolId,
    required this.toolName,
    this.imageUrl,
  });

  @override
  State<ToolDetailPage> createState() => _ToolDetailPageState();
}

class _ToolDetailPageState extends State<ToolDetailPage> {
  String? requestStatus;
  String? requestDocId;

  @override
  void initState() {
    super.initState();
    _fetchRequestStatus();
  }

  Future<void> _fetchRequestStatus() async {
    final query = await FirebaseFirestore.instance
        .collection('tool_requests')
        .where('toolId', isEqualTo: widget.toolId)
        .where('toolName', isEqualTo: widget.toolName)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      setState(() {
        requestStatus = doc['status'];
        requestDocId = doc.id;
      });
    }
  }

  Future<void> _requestTool() async {
    try {
      final newDoc = await FirebaseFirestore.instance
          .collection('tool_requests')
          .add({
        'toolId': widget.toolId,
        'toolName': widget.toolName,
        'imageUrl': widget.imageUrl,
        'requestedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      setState(() {
        requestStatus = 'pending';
        requestDocId = newDoc.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request sent for ${widget.toolName}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request failed: $e')),
      );
    }
  }

  Widget _buildRequestStatusWidget() {
    if (requestStatus == null) {
      // No request yet
      return SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
          onPressed: _requestTool,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0A57CF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Request Tool',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    } else if (requestStatus == 'pending') {
      return _statusText('✅ Request Submitted!\nYour request to check out has been sent to the admin.');
    } else if (requestStatus == 'accepted') {
      return _statusText('✅ Approved by Admin');
    } else if (requestStatus == 'declined') {
      return _statusText('❌ Rejected by Admin');
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _statusText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: Colors.green, size: 32),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff0A2342),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
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
            Text(
              widget.toolId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff0A2342),
              ),
            ),
            Text(
              widget.toolName,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            _buildRequestStatusWidget(),
            const SizedBox(height: 24),
            _infoCard(title: "Check-Out", time: "00:00 am", icon: Icons.logout),
            const SizedBox(height: 12),
            _infoCard(title: "Check-In", time: "00:00 am", icon: Icons.login),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String time,
    required IconData icon,
  }) {
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
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
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
