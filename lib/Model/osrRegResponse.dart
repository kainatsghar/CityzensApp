class OSRRegResponseModel {
  bool isSuccessful;
  String message;
  bool isException;
  ResponseInfo info;

  OSRRegResponseModel(
      {this.isSuccessful, this.message, this.isException, this.info});

  factory OSRRegResponseModel.fromJson(Map<String, dynamic> json) {
    return OSRRegResponseModel(
        info: json['OnlineStudentRegistration'] == null
            ? null
            : ResponseInfo.fromJson(json['OnlineStudentRegistration']),
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException']);
  }
}

class ResponseInfo {
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
  int websiteReferenceId;
  String websiteEntryDate;
  String paymentConfirmed;
  String previousSchoolName;
  String previousSchoolLocation;
  String studiedFromClass;
  String studiedToClass;
  String reasonForLeaving;
  int registrationEnquiryId;
  String registrationEnquiryStatus;
  String eRPRegistrationNumber;
  int organizationId;
  int feeStructureId;
  int createdBy;
  String creationDate;
  int lastUpdatedBy;
  String lastUpdateDate;

  ResponseInfo({
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
    this.websiteReferenceId,
    this.websiteEntryDate,
    this.paymentConfirmed,
    this.previousSchoolName,
    this.previousSchoolLocation,
    this.studiedFromClass,
    this.studiedToClass,
    this.reasonForLeaving,
    this.registrationEnquiryId,
    this.registrationEnquiryStatus,
    this.eRPRegistrationNumber,
    this.organizationId,
    this.feeStructureId,
    this.createdBy,
    this.creationDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
  });

  factory ResponseInfo.fromJson(Map json) {
    return ResponseInfo(
      firstName: json['FirstName']as String,
      surName: json['Surname']as String,
      gender: json['Gender'],
      dOB: json['DOB']as String,
      nationality: json['Nationality']as String,
      admissionRequiredSession: json['AdmissionRequiredSession']as String,
      city: json['City']as String,
      classId: json['ClassId']as String,
      branchCode: json['BranchCode']as String,
      guardianName: json['GuardianName']as String,
      guardianCNIC: json['GuardianCNIC'],
      guardianOccupation: json['GuardianOccupation']as String,
      guardianContactNumber: json['GuardianContactNumber']as String,
      guardianEmail: json['GuardianEmail']as String,
      websiteReferenceId: json['WebsiteReferenceId']as int,
      websiteEntryDate: json['WebsiteEntryDate']as String,
      paymentConfirmed: json['PaymentConfirmed']as String,
      previousSchoolName: json['PreviousSchoolName']as String,
      previousSchoolLocation: json['PreviousSchoolLocation']as String,
      studiedFromClass: json['StudiedFromClass']as String,
      studiedToClass: json['StudiedToClass']as String,
      reasonForLeaving: json['ReasonForLeaving']as String,
      registrationEnquiryId: json['RegistrationEnquiryId']as int,
      registrationEnquiryStatus: json['RegistrationEnquiryStatus']as String,
      eRPRegistrationNumber: json['ERPRegistrationNumber']as String,
      organizationId: json['OrganizationId']as int,
      feeStructureId: json['FeeStructureId']as int,
      createdBy: json['CreatedBy']as int,
      creationDate: json['CreationDate']as String,
      lastUpdatedBy: json['LastUpdatedBy']as int,
      lastUpdateDate: json['LastUpdateDate']as String,
    );
  }
}
