class TeacherProfileResponse {
  final String? region;
  final String? teacherName;
  final String? employeeCode;
  final String? branch;
  final String? gender;
  final String? maritalStatus;
  final String? cnicNumber;
  final String? designation;
  final String? religion;
  final String? address;
  final String? email;
  final String? city;
  final String? employeeCell;
  final bool? isSuccessful;
  final String? message;
  final bool? isException;

  TeacherProfileResponse({
    this.region,
    this.teacherName,
    this.employeeCode,
    this.branch,
    this.gender,
    this.maritalStatus,
    this.cnicNumber,
    this.designation,
    this.religion,
    this.address,
    this.email,
    this.city,
    this.employeeCell,
    this.isSuccessful,
    this.message,
    this.isException,
  });

  factory TeacherProfileResponse.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) => value?.toString().trim();

    return TeacherProfileResponse(
      city: safeString(json['CITY']),
      email: safeString(json['EmployeeEmail']),
      address: safeString(json['Official_Address']),
      religion: safeString(json['Religion']),
      designation: safeString(json['Designation']),
      cnicNumber: safeString(json['CNIC']),
      gender: safeString(json['Gender']),
      maritalStatus: safeString(json['MStatus']),
      branch: safeString(json['Branch']),
      employeeCell: safeString(json['Employee_Cell']),
      region: safeString(json['Region']),
      teacherName: safeString(json['Name']),
      employeeCode: safeString(json['EmployeeCode']),
      isSuccessful: json['IsSuccessful'] as bool?,
      message: safeString(json['Message']),
      isException: json['IsServerException'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CITY': city,
      'EmployeeEmail': email,
      'Official_Address': address,
      'Religion': religion,
      'Designation': designation,
      'CNIC': cnicNumber,
      'Gender': gender,
      'MStatus': maritalStatus,
      'Branch': branch,
      'Employee_Cell': employeeCell,
      'Region': region,
      'Name': teacherName,
      'EmployeeCode': employeeCode,
      'IsSuccessful': isSuccessful,
      'Message': message,
      'IsServerException': isException,
    };
  }

  bool get isMale => gender == 'Male';
}
