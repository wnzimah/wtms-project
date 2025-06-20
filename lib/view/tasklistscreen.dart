import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/worker.dart';
import '../model/work.dart';
import '../myconfig.dart';
import 'submitcompletionscreen.dart';

class TaskListScreen extends StatefulWidget {
  final Worker worker;
  const TaskListScreen({super.key, required this.worker});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Work> taskList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      var response = await http.post(
        Uri.parse("${MyConfig.myurl}/wtms/wtms/php/get_works.php"),
        body: {"worker_id": widget.worker.workerId!},
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          List tasks = jsonData['data'];
          setState(() {
            taskList = tasks.map((t) => Work.fromJson(t)).toList();
            isLoading = false;
          });
        } else {
          showError("No tasks found");
        }
      } else {
        showError("Error: ${response.statusCode}");
      }
    } catch (e) {
      showError("Failed to fetch tasks: $e");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() => isLoading = false);
  }

  bool isOverdue(String dueDateStr) {
    try {
      final dueDate = DateTime.parse(dueDateStr);
      final today = DateTime.now();
      return dueDate.isBefore(DateTime(today.year, today.month, today.day));
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFFFF0F2); // Light rose

    return Container(
      color: backgroundColor,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskList.isEmpty
              ? const Center(
                  child: Text(
                    "No tasks assigned.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    final isCompleted = task.status.toLowerCase() == 'completed';
                    final overdue = !isCompleted && isOverdue(task.dueDate);

                    return InkWell(
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubmitCompletionScreen(
                              worker: widget.worker,
                              work: task,
                            ),
                          ),
                        );
                        if (updated == true) {
                          fetchTasks(); // Refresh after submit
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title + arrow
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Description
                              Text(
                                task.description,
                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                              ),

                              const SizedBox(height: 10),

                              // Due date
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Due: ${task.dueDate}",
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Bottom row: instruction + status badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  task.status.toLowerCase() == 'pending'
                                      ? const Text(
                                          "Tap to submit your work",
                                          style: TextStyle(fontSize: 11, color: Colors.black54),
                                        )
                                      : const SizedBox(),
                                  _buildStatusBadge(task.status, isCompleted, overdue),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildStatusBadge(String status, bool isCompleted, bool isOverdue) {
    Color bgColor;
    Color textColor;
    IconData icon;

    if (isCompleted) {
      bgColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      icon = Icons.check_circle;
    } else if (isOverdue) {
      bgColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      icon = Icons.warning_amber_rounded;
    } else {
      bgColor = Colors.orange[100]!;
      textColor = Colors.orange[800]!;
      icon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            isOverdue ? "OVERDUE" : status.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
