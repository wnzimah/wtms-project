import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/submission.dart';
import '../model/worker.dart';
import '../myconfig.dart';
import 'editsubmissionscreen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final Worker worker;
  const SubmissionHistoryScreen({super.key, required this.worker});

  @override
  State<SubmissionHistoryScreen> createState() =>
      _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List<Submission> submissionList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.myurl}/wtms/wtms/php/get_submissions.php"),
        body: {"worker_id": widget.worker.workerId ?? ''},
      ).timeout(const Duration(seconds: 12));

      final raw = response.body.trim();
      if (!raw.startsWith('{')) {
        showError('Server sent non‑JSON:\n$raw');
        return;
      }

      final data = json.decode(raw);
      if (data['status'] == 'success') {
        final submissions = data['data'] as List;
        setState(() {
          submissionList =
              submissions.map((e) => Submission.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        showError(data['data'] ?? 'No submissions found');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFFFF0F2); // soft pink

    return Scaffold(
      backgroundColor: bgColor,
      // ❌ TIADA appBar DI SINI – gunakan AppBar induk
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : submissionList.isEmpty
                ? const Center(child: Text('No submission history yet.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: submissionList.length,
                    itemBuilder: (context, index) {
                      final s = submissionList[index];
                      final preview = s.submissionText.length > 80
                          ? '${s.submissionText.substring(0, 80)}...'
                          : s.submissionText;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding:
                                const EdgeInsets.fromLTRB(16, 14, 16, 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(30, 0, 0, 0),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Task Title
                                Row(
                                  children: [
                                    const Icon(Icons.work_outline_rounded,
                                        size: 22, color: Colors.deepPurple),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        s.taskTitle,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Date
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      s.submissionDate,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Preview Label
                                Row(
                                  children: const [
                                    Icon(Icons.description_outlined,
                                        size: 18, color: Colors.purple),
                                    SizedBox(width: 6),
                                    Text(
                                      "Preview:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Preview Text
                                Text(
                                  preview,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Edit Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () async {
                                      final updated = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditSubmissionScreen(
                                              submission: s),
                                        ),
                                      );
                                      if (updated == true) {
                                        fetchSubmissions();
                                      }
                                    },
                                    icon: const Icon(Icons.edit_note_rounded,
                                        size: 18),
                                    label: const Text("Edit Task"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.orange[800],
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
