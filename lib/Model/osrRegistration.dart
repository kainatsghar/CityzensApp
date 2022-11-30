class OSRRegistrationModel {
  Info info;

  OSRRegistrationModel({this.info});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> registration = new Map<String, dynamic>();
    if (this.info != null) {
      registration['OnlineStudentRegistration'] = this.info.toJson();
    }
    return registration;
  }
}

class Info {
  String firstName;
  String surName;
  String gender;
  String dOB;
  String nationality;
  String admissionRequiredSession;
  String city;
  String classId;
  String branchCode;
  String guardianName;
  String guardianCNIC;
  String guardianOccupation;
  String guardianContactNumber;
  String guardianEmail;
  String previousSchoolName;
  String previousSchoolLocation;
  String studiedFromClass;
  String studiedToClass;
  String reasonForLeaving;

  Info({
    this.firstName,
    this.surName,
    this.gender,
    this.dOB,
    this.nationality,
    this.admissionRequiredSession,
    this.city,
    this.classId,
    this.branchCode,
    this.guardianName,
    this.guardianCNIC,
    this.guardianOccupation,
    this.guardianContactNumber,
    this.guardianEmail,
    this.previousSchoolName,
    this.previousSchoolLocation,
    this.studiedFromClass,
    this.studiedToClass,
    this.reasonForLeaving
  });

  Map<String, dynamic> toJson() {
    var json = new Map<String, dynamic>();
    json['FirstName'] = firstName;
    json['Surname'] = surName;
    json['Gender'] = gender;
    json['DOB'] = dOB;
    json['Nationality'] = nationality;
    json['AdmissionRequiredSession'] = admissionRequiredSession;
    json['City'] = city;
    json['ClassId'] = classId;
    json['BranchCode'] = branchCode;
    json['GuardianName'] = guardianName;
    json['GuardianCNIC'] = guardianCNIC;
    json['GuardianOccupation'] = guardianOccupation;
    json['GuardianContactNumber'] = guardianContactNumber;
    json['GuardianEmail'] = guardianEmail;
    json['PreviousSchoolName'] = previousSchoolName;
    json['PreviousSchoolLocation'] = previousSchoolLocation;
    json['StudiedFromClass'] = studiedFromClass;
    json['StudiedToClass'] = studiedToClass;
    json['ReasonForLeaving'] = reasonForLeaving;
    return json;
  }
}
