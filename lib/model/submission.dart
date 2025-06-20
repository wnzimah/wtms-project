class Submission {
  final String id;
  final String taskTitle;
  final String submissionText;
  final String submissionDate;

  Submission({
    required this.id,
    required this.taskTitle,
    required this.submissionText,
    required this.submissionDate,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: (json['submission_id'] ?? json['id'] ?? '').toString(),
      taskTitle: json['task_title'] ?? 'Untitled task',
      submissionText: json['submission_text'] ?? '',
      submissionDate: json['submission_date'] ?? json['submitted_at'] ?? '',
    );
  }
}
