class Worker {
  String? workerId;
  String? workerName;
  String? workerEmail;
  String? workerPhone;
  String? workerAddress;

  Worker({
    this.workerId,
    this.workerName,
    this.workerEmail,
    this.workerPhone,
    this.workerAddress,
  });

  //ni convert JSON to Worker object
  Worker.fromJson(Map<String, dynamic> json) {
    workerId = json['id'].toString();
    workerName = json['full_name']; 
    workerEmail = json['email'];
    workerPhone = json['phone'];
    workerAddress = json['address'];
  }

  // untuk convert Worker object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': workerId,
      'full_name': workerName, 
      'email': workerEmail,
      'phone': workerPhone,
      'address': workerAddress,
    };
  }
}
