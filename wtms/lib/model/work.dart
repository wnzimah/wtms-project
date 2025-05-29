class Work {
  final String id;
  final String title;
  final String description;
  final String dateAssigned;
  final String dueDate;
  final String status;

  Work({
    required this.id,
    required this.title,
    required this.description,
    required this.dateAssigned,
    required this.dueDate,
    required this.status,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['id'].toString(),   
      title: json['title'],
      description: json['description'],
      dateAssigned: json['date_assigned'],
      dueDate: json['due_date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_assigned': dateAssigned,
      'due_date': dueDate,
      'status': status,
    };
  }
}
