import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/worker.dart';
import '../myconfig.dart';
import 'editprofilescreen.dart';

class ProfileScreen extends StatefulWidget {
  final Worker worker;
  const ProfileScreen({super.key, required this.worker});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Worker currentWorker;

  @override
  void initState() {
    super.initState();
    currentWorker = widget.worker;
  }

  Future<void> _refreshProfile() async {
    final res = await http.post(
      Uri.parse("${MyConfig.myurl}/wtms/wtms/php/get_profile.php"),
      body: {"worker_id": currentWorker.workerId},
    );
    final data = json.decode(res.body);
    if (data['status'] == 'success') {
      final u = data['data'];
      setState(() {
        currentWorker.workerName = u['full_name'];
        currentWorker.workerEmail = u['email'];
        currentWorker.workerPhone = u['phone'];
        currentWorker.workerAddress = u['address'];
        currentWorker.workerUsername = u['username'];
      });
    }
  }

  Future<void> _editProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(worker: currentWorker),
      ),
    );
    if (updated == true) _refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF8E0038);
    const bg = Color(0xFFFFF0F2);

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: Colors.grey.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Icon
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),

                // Username
                Text(
                  currentWorker.workerUsername ?? '-',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: maroon,
                  ),
                ),

                const SizedBox(height: 16),

                // Info Items
                _item(Icons.badge, "Worker ID", currentWorker.workerId ?? '-'),
                _item(Icons.person, "Full Name", currentWorker.workerName ?? '-'),
                _item(Icons.email, "Email", currentWorker.workerEmail ?? '-'),
                _item(Icons.phone, "Phone", currentWorker.workerPhone ?? '-'),
                _item(Icons.location_on, "Address", currentWorker.workerAddress ?? '-'),

                const SizedBox(height: 24),

                // Edit Button
                SizedBox(
                  width: 160,
                  height: 42,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    label: const Text("Edit Profile",
                        style: TextStyle(color: Colors.white)),
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maroon,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
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

  Widget _item(IconData ic, String label, String value) {
    const maroon = Color(0xFF8E0038);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ic, color: maroon, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
