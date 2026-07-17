class ResultsResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  StudentInfo? info;
  List<Detail>? listDetail;
  List<PDFResults>? pdfResultslist;

  ResultsResponse({
    this.isSuccessful,
    this.message,
    this.isException,
    this.info,
    this.listDetail,
    this.pdfResultslist,
  });

  factory ResultsResponse.fromJson(Map json) {
    // Ensure "Results" and "PDFResults" are not null and have correct type
    var list = json['Results'] as List? ?? [];
    List<Detail> detailList = list.map((i) => Detail.fromJson(i)).toList();

    var listpdf = json['PDFResults'] as List? ?? [];
    List<PDFResults> listpdfresult = listpdf
        .map((i) => PDFResults.fromJson(i))
        .toList();

    return ResultsResponse(
      isSuccessful: json['IsSuccessful'] ?? false,
      message: json['Message'] ?? '',
      isException: json['IsServerException'] ?? false,
      listDetail: detailList,
      info: StudentInfo.fromJson(json['StudentInfo'] ?? {}),
      pdfResultslist: listpdfresult,
    );
  }
}

class StudentInfo {
  String? name;
  int? rollNo;
  String? className;
  String? centerName;
  String? regionName;
  int? term;
  int? sessionId;
  String? section;
  String? promotedTo;
  String? teacherComment;
  String? overallGrade;
  double? overallPercentage;
  double? highestPercentage;
  double? lowestPercentage;
  double? average;
  int? gradeId;

  StudentInfo({
    this.gradeId,
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
    this.overallPercentage,
  });

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
      overallPercentage: json['Overall_P'],
    );
  }
}

class Detail {
  String? subject;
  String? grade;
  String? theoryExam;
  double? courseWork;
  String? midYear;
  double? marks;

  Detail({
    this.subject,
    this.grade,
    this.theoryExam,
    this.courseWork,
    this.midYear,
    this.marks,
  });

  factory Detail.fromJson(Map json) {
    return Detail(
      subject: json['Subject_Name'] as String,
      grade: json['Grade'] as String,
      theoryExam: json['Theory_Exam'] as String,
      midYear: json['Mid_Year'] as String,
      courseWork: json['Course_Work'] as double,
      marks: json['Marks'] as double,
    );
  }
}

class EyeResult {
  String subjectName;
  List<SubjectDetails> details;

  EyeResult(this.subjectName, this.details);
}

class SubjectDetails {
  String? classTeacherComments;
  String? description;
  String? subjectName;
  String? kLO;
  int? key1;
  int? key2;
  int? key3;
  int? key4;

  SubjectDetails({
    this.classTeacherComments,
    this.description,
    this.subjectName,
    this.kLO,
    this.key1,
    this.key2,
    this.key3,
    this.key4,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClassTeacherComments'] = classTeacherComments;
    data['Description'] = description;
    data['Subject_Name'] = subjectName;
    data['KLO'] = kLO;
    data['Key1'] = key1;
    data['Key2'] = key2;
    data['Key3'] = key3;
    data['Key4'] = key4;
    return data;
  }
}

class PDFResults {
  int? studentId;
  int? classId;
  int? sessionId;
  int? sectionId;
  int? termGroupId;
  String? url;
  String? pdfUrl;
  String? documentId;

  PDFResults({
    this.studentId,
    this.classId,
    this.sessionId,
    this.sectionId,
    this.termGroupId,
    this.url,
    this.pdfUrl,
    this.documentId,
  });

  factory PDFResults.fromJson(Map<String, dynamic> json) {
    return PDFResults(
      studentId: json['StudentId'],
      classId: json['ClassId'],
      sessionId: json['SessionId'],
      sectionId: json['SectionId'],
      termGroupId: json['TermGroupId'],
      url: json['URL'],
      pdfUrl: json['PDFURL'] ?? json['DownloadUrl'] ?? json['PdfUrl'],
      documentId: json['Document_Id']?.toString() ??
          json['ResultDocumentId']?.toString(),
    );
  }
}
