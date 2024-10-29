class SchoolEventRequest {
  int? id;
  bool? isStudent;

  SchoolEventRequest({this.id, this.isStudent});

  SchoolEventRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    isStudent = json['IsStudent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['IsStudent'] = isStudent;
    return data;
  }
}
