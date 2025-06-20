class Worker {
  String? workerId;
  String? workerName;
  String? workerUsername; // NEW
  String? workerEmail;
  String? workerPhone;
  String? workerAddress;

  Worker({
    this.workerId,
    this.workerName,
    this.workerUsername, // NEW
    this.workerEmail,
    this.workerPhone,
    this.workerAddress,
  });

  // Convert JSON to Worker object
  Worker.fromJson(Map<String, dynamic> json) {
    workerId       = json['id'].toString();
    workerName     = json['full_name'];
    workerUsername = json['username'];         // NEW
    workerEmail    = json['email'];
    workerPhone    = json['phone'];
    workerAddress  = json['address'];
  }

  // Convert Worker object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': workerId,
      'full_name': workerName,
      'username': workerUsername,              // NEW
      'email': workerEmail,
      'phone': workerPhone,
      'address': workerAddress,
    };
  }
}
