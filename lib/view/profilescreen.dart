import 'package:flutter/material.dart';
import '../model/worker.dart';
import 'loginscreen.dart';
import 'TaskListScreen.dart';

class ProfileScreen extends StatefulWidget {
  final Worker worker;
  const ProfileScreen({super.key, required this.worker});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF8E0038); // Maroon utama
    const Color backgroundColor = Color(0xFFFFF0F2); // ✅ Light Rose

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: themeColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.worker.workerName ?? "No Name",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(Icons.badge, "Worker ID", widget.worker.workerId ?? "-"),
                  _buildProfileItem(Icons.email, "Email", widget.worker.workerEmail ?? "-"),
                  _buildProfileItem(Icons.phone, "Phone", widget.worker.workerPhone ?? "-"),
                  _buildProfileItem(Icons.location_on, "Address", widget.worker.workerAddress ?? "-"),
                  const SizedBox(height: 24),

                  // My Tasks button
                  SizedBox(
                    width: 160,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskListScreen(worker: widget.worker),
                          ),
                        );
                      },
                      icon: const Icon(Icons.task_alt, color: Colors.white, size: 18),
                      label: const Text("My Tasks", style: TextStyle(color: Colors.white, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logout button
                  SizedBox(
                    width: 160,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white, size: 18),
                      label: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 5,
                        shadowColor: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    const Color iconColor = Color(0xFF8E0038);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
