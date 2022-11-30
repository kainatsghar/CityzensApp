class ResultsResponse {
  bool isSuccessful;
  String message;
  bool isException;
  StudentInfo info;
  List<Detail> listDetail;

  ResultsResponse(
      {this.isSuccessful,
      this.message,
      this.isException,
      this.info,
      this.listDetail});

  factory ResultsResponse.fromJson(Map json) {
    var list = json['Results'] as List;
    List<Detail> detailList = list.map((i) => Detail.fromJson(i)).toList();
    return ResultsResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        listDetail: detailList,
        info: StudentInfo.fromJson(json['StudentInfo'] ?? {}));
  }
}

class StudentInfo {
  String name;
  int rollNo;
  String className;
  String centerName;
  String regionName;
  int term;
  int sessionId;
  String section;
  String promotedTo;
  String teacherComment;
  String overallGrade;
  double overallPercentage;
  double highestPercentage;
  double lowestPercentage;
  double average;
  int gradeId;

  StudentInfo(
      {this.gradeId,
      this.name,
      this.rollNo,
      this.className,
      this.centerName,
      this.regionName,
      this.term,
      this.sessionId,
      this.section,
      this.promotedTo,
      this.teacherComment,
      this.overallGrade,
      this.average,
      this.highestPercentage,
      this.lowestPercentage,
      this.overallPercentage});

  factory StudentInfo.fromJson(Map json) {
    return StudentInfo(
        gradeId: json['Grade_Id'],
        name: json['StudentName'],
        rollNo: json['Student_Id'],
        className: json['Class_Name'],
        centerName: json['Center_Name'],
        regionName: json['Region_Name'],
        term: json['Term'],
        sessionId: json['Session_Id'],
        section: json['Section_Name'],
        promotedTo: json['PromotedToClass'],
        teacherComment: json['ClassTeacher_Comments'],
        overallGrade: json['Overall_G'],
        average: json['Class_Average'],
        highestPercentage: json['Class_Heighest'],
        lowestPercentage: json['ClassMinimum'],
        overallPercentage: json['Overall_P']);
  }
}

class Detail {
  String subject;
  String grade;
  String theoryExam;
  double courseWork;
  String midYear;
  double marks;

  Detail(
      {this.subject,
      this.grade,
      this.theoryExam,
      this.courseWork,
      this.midYear,
      this.marks});

  factory Detail.fromJson(Map json) {
    return Detail(
        subject: json['Subject_Name'] as String,
        grade: json['Grade'] as String,
        theoryExam: json['Theory_Exam'] as String,
        midYear: json['Mid_Year'] as String,
        courseWork: json['Course_Work'] as double,
        marks: json['Marks'] as double);
  }
}

class EyeResult {
  String subjectName;
  List<SubjectDetails> details;

  EyeResult(this.subjectName, this.details);
}

class SubjectDetails {
  String classTeacherComments;
  String description;
  String subjectName;
  String kLO;
  int key1;
  int key2;
  int key3;
  int key4;

  SubjectDetails(
      {this.classTeacherComments,
      this.description,
      this.subjectName,
      this.kLO,
      this.key1,
      this.key2,
      this.key3,
      this.key4});

  SubjectDetails.fromJson(Map<String, dynamic> json) {
    classTeacherComments = json['ClassTeacherComments'];
    description = json['Description'];
    subjectName = json['Subject_Name'];
    kLO = json['KLO'];
    key1 = json['Key1'];
    key2 = json['Key2'];
    key3 = json['Key3'];
    key4 = json['Key4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassTeacherComments'] = this.classTeacherComments;
    data['Description'] = this.description;
    data['Subject_Name'] = this.subjectName;
    data['KLO'] = this.kLO;
    data['Key1'] = this.key1;
    data['Key2'] = this.key2;
    data['Key3'] = this.key3;
    data['Key4'] = this.key4;
    return data;
  }
}
