import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/worker.dart';
import '../myconfig.dart';

class EditProfileScreen extends StatefulWidget {
  final Worker worker;
  const EditProfileScreen({super.key, required this.worker});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController usernameC;
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController phoneC;
  late TextEditingController addressC;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    usernameC = TextEditingController(text: widget.worker.workerUsername ?? '');
    nameC     = TextEditingController(text: widget.worker.workerName ?? '');
    emailC    = TextEditingController(text: widget.worker.workerEmail ?? '');
    phoneC    = TextEditingController(text: widget.worker.workerPhone ?? '');
    addressC  = TextEditingController(text: widget.worker.workerAddress ?? '');
  }

  Future<void> saveProfile() async {
    setState(() => isSaving = true);
    try {
      final res = await http.post(
        Uri.parse("${MyConfig.myurl}/wtms/wtms/php/update_profile.php"),
        body: {
          "worker_id": widget.worker.workerId,
          "full_name": nameC.text,
          "email": emailC.text,
          "phone": phoneC.text,
          "address": addressC.text,
        },
      );
      final data = json.decode(res.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile succesful updated")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${data['data']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  Widget _field(String label, TextEditingController controller,
      {bool enabled = true, int maxLines = 1, TextInputType type = TextInputType.text}) {
    const maroon = Color(0xFF8E0038);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: type,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: maroon, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF8E0038);
    const bg = Color(0xFFFFF0F2);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: maroon,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _field("Username", usernameC, enabled: false),
                _field("Full Name", nameC),
                _field("Email", emailC, type: TextInputType.emailAddress),
                _field("Phone", phoneC, type: TextInputType.phone),
                _field("Address", addressC, maxLines: 2),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : saveProfile,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(
                      isSaving ? "Saving..." : "Save",
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maroon,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
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
