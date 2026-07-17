class StudentTestResultListRequest {
  int? status;
  int? id;

  StudentTestResultListRequest({
    this.status,
    this.id,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status ?? '';
    data['Id'] = id ?? '';
    return data;
  }
}
