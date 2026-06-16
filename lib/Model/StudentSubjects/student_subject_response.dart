class StudentSubjectResponse {
  List<StudentSubject>? studentSubjects;
  bool? isSuccessful;
  String? message;
  bool? isServerException;

  StudentSubjectResponse({
    this.studentSubjects,
    this.isSuccessful,
    this.message,
    this.isServerException,
  });

  factory StudentSubjectResponse.fromJson(Map<String, dynamic> json) {
    return StudentSubjectResponse(
      studentSubjects: json['StudentSubjects'] != null
          ? List<StudentSubject>.from(
              json['StudentSubjects'].map((v) => StudentSubject.fromJson(v)))
          : null,
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isServerException: json['IsServerException'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentSubjects': studentSubjects?.map((v) => v.toJson()).toList(),
      'IsSuccessful': isSuccessful,
      'Message': message,
      'IsServerException': isServerException,
    };
  }
}

class StudentSubject {
  int? studentSectionSubjectId;
  int? studentId;
  int? sectionSubjectId;
  int? sessionId;
  String? subjectName;
  int? classId;
  String? className;
  String? sectionName;
  String? studentNo;
  String? firstName;
  String? middleName;
  String? lastName;
  int? mainOrganisationId;
  int? studentCenterId;
  int? assignedCenterId;
  int? assignedSectionId;
  int? actualSectionId;
  String? centerName;
  int? regionId;
  String? regionName;
  int? subjectId;
  String? userName;
  String? password;
  String? fullName;
  int? studentStatusId;
  int? classSectionId;
  int? ascTSubjectId;
  int? ascTClassSectionId;
  int? currentClass;
  int? genderId;

  StudentSubject({
    this.studentSectionSubjectId,
    this.studentId,
    this.sectionSubjectId,
    this.sessionId,
    this.subjectName,
    this.classId,
    this.className,
    this.sectionName,
    this.studentNo,
    this.firstName,
    this.middleName,
    this.lastName,
    this.mainOrganisationId,
    this.studentCenterId,
    this.assignedCenterId,
    this.assignedSectionId,
    this.actualSectionId,
    this.centerName,
    this.regionId,
    this.regionName,
    this.subjectId,
    this.userName,
    this.password,
    this.fullName,
    this.studentStatusId,
    this.classSectionId,
    this.ascTSubjectId,
    this.ascTClassSectionId,
    this.currentClass,
    this.genderId,
  });

  factory StudentSubject.fromJson(Map<String, dynamic> json) {
    return StudentSubject(
      studentSectionSubjectId: json['Student_Section_Subject_Id'],
      studentId: json['Student_Id'],
      sectionSubjectId: json['Section_Subject_Id'],
      sessionId: json['Session_Id'],
      subjectName: json['Subject_Name'],
      classId: json['Class_Id'],
      className: json['Class_Name'],
      sectionName: json['Section_Name'],
      studentNo: json['Student_No'],
      firstName: json['First_Name'],
      middleName: json['Middle_Name'],
      lastName: json['Last_Name'],
      mainOrganisationId: json['Main_Organisation_Id'],
      studentCenterId: json['Student_Center_Id'],
      assignedCenterId: json['Assigned_Center_Id'],
      assignedSectionId: json['AssignedSection_Id'],
      actualSectionId: json['ActualSection_Id'],
      centerName: json['Center_Name'],
      regionId: json['Region_Id'],
      regionName: json['Region_Name'],
      subjectId: json['Subject_Id'],
      userName: json['User_Name'],
      password: json['Password'],
      fullName: json['FullName'],
      studentStatusId: json['Student_Status_Id'],
      classSectionId: json['Class_Section_Id'],
      ascTSubjectId: json['AscTSubject_Id'],
      ascTClassSectionId: json['AscTClassSection_Id'],
      currentClass: json['CurrentClass'],
      genderId: json['Gender_Id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Student_Section_Subject_Id': studentSectionSubjectId,
      'Student_Id': studentId,
      'Section_Subject_Id': sectionSubjectId,
      'Session_Id': sessionId,
      'Subject_Name': subjectName,
      'Class_Id': classId,
      'Class_Name': className,
      'Section_Name': sectionName,
      'Student_No': studentNo,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'Main_Organisation_Id': mainOrganisationId,
      'Student_Center_Id': studentCenterId,
      'Assigned_Center_Id': assignedCenterId,
      'AssignedSection_Id': assignedSectionId,
      'ActualSection_Id': actualSectionId,
      'Center_Name': centerName,
      'Region_Id': regionId,
      'Region_Name': regionName,
      'Subject_Id': subjectId,
      'User_Name': userName,
      'Password': password,
      'FullName': fullName,
      'Student_Status_Id': studentStatusId,
      'Class_Section_Id': classSectionId,
      'AscTSubject_Id': ascTSubjectId,
      'AscTClassSection_Id': ascTClassSectionId,
      'CurrentClass': currentClass,
      'Gender_Id': genderId,
    };
  }
}
