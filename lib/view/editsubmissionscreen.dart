import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/submission.dart';
import '../myconfig.dart';

class EditSubmissionScreen extends StatefulWidget {
  final Submission submission;
  const EditSubmissionScreen({super.key, required this.submission});

  @override
  State<EditSubmissionScreen> createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  late TextEditingController _controller;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.submission.submissionText);
  }

  Future<void> updateSubmission() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submission text cannot be empty")),
      );
      return;
    }

    // ───── Confirmation Dialog ─────
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Update"),
        content: const Text("Are you sure you want to update this submission?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8E0038)),
            child: const Text("Yes, Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isUpdating = true);
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.myurl}/wtms/wtms/php/edit_submission.php"),
        body: {
          "submission_id": widget.submission.id,
          "updated_text": text,
        },
      ).timeout(const Duration(seconds: 10));

      final raw = response.body.trim();
      if (!raw.startsWith('{')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error:\n$raw")),
        );
        return;
      }

      final jsonData = json.decode(raw);
      if (jsonData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission updated successfully")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${jsonData['data']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    } finally {
      setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF8E0038);
    const bg = Color(0xFFFFF0F2);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Edit Submission", style: TextStyle(color: Colors.white)),
        backgroundColor: maroon,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 8,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: "Submission Text",
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: maroon, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: isUpdating ? null : updateSubmission,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  isUpdating ? "Saving..." : "Save",
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
    );
  }
}
