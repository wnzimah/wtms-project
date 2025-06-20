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
    try {
      final response = await http
          .post(
            Uri.parse("${MyConfig.myurl}/wtms/wtms/php/get_submissions.php"),
            body: {"worker_id": widget.worker.workerId!},
          )
          .timeout(const Duration(seconds: 10));

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
      showError('Exception: $e');
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFFFF0F2);
    const maroon = Color(0xFF8E0038);

    Widget body;
    if (isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (submissionList.isEmpty) {
      body = const Center(child: Text('No submission history yet.'));
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: submissionList.length,
        itemBuilder: (context, index) {
          final s = submissionList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                s.taskTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Submitted: ${s.submissionDate}'),
                  const SizedBox(height: 4),
                  Text(
                    s.submissionText.length > 60
                        ? '${s.submissionText.substring(0, 60)}…'
                        : s.submissionText,
                  ),
                ],
              ),
              trailing: const Icon(Icons.edit, color: maroon, size: 18),
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditSubmissionScreen(submission: s),
                  ),
                );
                if (updated == true) fetchSubmissions();
              },
            ),
          );
        },
      );
    }

    return Container(
      color: background,
      child: body,
    );
  }
}
