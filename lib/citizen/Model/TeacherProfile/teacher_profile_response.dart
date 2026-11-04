class TeacherProfileResponse {
  String? region;
  String? teacherName;
  String? employeeCode;
  String? branch;
  String? maritalStatus;
  String? cnicNumber;
  String? designation;
  String? religion;
  String? address;
  String? email;
  String? city;
  String? employeeCell;
  bool? isSuccessful;
  String? message;
  bool? isException;

  TeacherProfileResponse(
      {this.region,
        this.teacherName,
        this.employeeCode,
        this.branch,
        this.maritalStatus,
        this.designation,
        this.religion,
        this.address,
        this.email,
        this.city,
        this.isSuccessful,
        this.message,
        this.isException,
        this.employeeCell,
        this.cnicNumber});

  factory TeacherProfileResponse.fromJson(Map<String, dynamic> parsedJson) {
    return TeacherProfileResponse(
        city: parsedJson['CITY'],
        email: parsedJson['EmployeeEmail'],
        address: parsedJson['Official_Address'],
        religion: parsedJson['Religion'],
        designation: parsedJson['Designation'],
        cnicNumber: parsedJson['CNIC'],
        maritalStatus: parsedJson['MStatus'],
        branch: parsedJson['Branch'],
        employeeCell: parsedJson['Employee_Cell'],
        region: parsedJson['Region'],
        teacherName: parsedJson['Name'],
        isSuccessful: parsedJson['IsSuccessful'],
        message: parsedJson['Message'],
        isException: parsedJson['IsServerException'],
        employeeCode: parsedJson['EmployeeCode']);
  }
}
