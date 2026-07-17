class AcademicTermResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  List<AcademicTerm>? session;
  List<AcademicTerm>? term;

  AcademicTermResponse(
      {this.isSuccessful,
      this.message,
      this.isException,
      this.session,
      this.term});

  factory AcademicTermResponse.fromJson(Map json) {
    var list = json['Session'] as List;
    List<AcademicTerm> sessionList =
        list.map((i) => AcademicTerm.fromJson(i)).toList();
    var list1 = json['Term'] as List;
    List<AcademicTerm> termList =
        list1.map((i) => AcademicTerm.fromJson(i)).toList();
    return AcademicTermResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        session: sessionList,
        term: termList);
  }
}

class AcademicTerm {
  int? id;
  String? name;

  AcademicTerm({this.id, this.name});

  factory AcademicTerm.fromJson(Map json) {
    return AcademicTerm(id: json['Id'], name: json['Name']);
  }
}
