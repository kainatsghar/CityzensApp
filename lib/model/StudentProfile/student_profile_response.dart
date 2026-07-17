class StudentProfileResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  bool? isInvstrMenueEnable;
  List<Profile>? profile;

  StudentProfileResponse({
    this.isSuccessful,
    this.message,
    this.isException,
    this.isInvstrMenueEnable,
    this.profile,
  });

  factory StudentProfileResponse.fromJson(Map json) {
    var list = json['profile'] as List?;
    List<Profile>? profileList = list?.map((i) => Profile.fromJson(i)).toList();
    return StudentProfileResponse(
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isException: json['IsServerException'],
      isInvstrMenueEnable: json['IsInvstrMenueEnable'],
      profile: profileList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsSuccessful': isSuccessful,
      'Message': message,
      'IsServerException': isException,
      'IsInvstrMenueEnable': isInvstrMenueEnable,
      'profile': profile?.map((e) => e.toJson()).toList(),
    };
  }
}

class Profile {
  int? studentId;
  int? aimsId;
  int? studentStatusId;
  int? mainOrganisationId;
  String? studentNo;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  String? address;
  String? telephoneNo;
  String? primaryContactNo;
  String? contactNo;
  int? genderId;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? comments;
  int? regionId;
  int? centerId;
  int? gradeId;
  String? approvalDate;
  String? applicationDate;
  String? transferDate;
  String? dropDate;
  String? fatherEmail;
  String? studentNoI;
  String? name;
  String? prevClass;
  String? erpClass;
  String? promotedTo;
  String? remarks;
  String? region;
  String? center;
  String? className;
  String? tokenId;

  Profile({
    this.studentId,
    this.aimsId,
    this.studentStatusId,
    this.mainOrganisationId,
    this.studentNo,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.address,
    this.telephoneNo,
    this.primaryContactNo,
    this.contactNo,
    this.genderId,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.comments,
    this.regionId,
    this.centerId,
    this.gradeId,
    this.approvalDate,
    this.applicationDate,
    this.transferDate,
    this.dropDate,
    this.fatherEmail,
    this.studentNoI,
    this.name,
    this.prevClass,
    this.erpClass,
    this.promotedTo,
    this.remarks,
    this.region,
    this.center,
    this.className,
    this.tokenId,
  });

  factory Profile.fromJson(Map json) {
    return Profile(
      studentId: json['Student_Id'],
      aimsId: json['Aims_Id'],
      studentStatusId: json['Student_Status_Id'],
      mainOrganisationId: json['Main_Organisation_Id'],
      studentNo: json['Student_No'],
      firstName: json['First_Name'],
      middleName: json['Middle_Name'],
      lastName: json['Last_Name'],
      dateOfBirth: json['Date_Of_Birth'],
      address: json['Address'],
      telephoneNo: json['Telephone_No'],
      primaryContactNo: json['PrimaryContactNo'],
      contactNo: json['PrimaryContactNo'] ?? json['Telephone_No'],
      genderId: json['Gender_Id'],
      city: json['City'],
      state: json['State'],
      country: json['Country'],
      postalCode: json['Postal_Code'],
      comments: json['Comments'],
      regionId: json['Region_Id'],
      centerId: json['Center_Id'],
      gradeId: json['Grade_Id'],
      approvalDate: json['Approval_Date'],
      applicationDate: json['Application_Date'],
      transferDate: json['Transfer_Date'],
      dropDate: json['Drop_Date'],
      fatherEmail: json['FatherEmail'],
      studentNoI: json['Student_noI'],
      name: json['fullname'],
      prevClass: json['PrevClass'],
      erpClass: json['ErpClass'],
      promotedTo: json['PromotedTo'],
      remarks: json['Remarks'],
      region: json['Region_Name'],
      center: json['Center_Name'],
      className: json['Class_Name'],
      tokenId: json['TokenId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Student_Id': studentId,
      'Aims_Id': aimsId,
      'Student_Status_Id': studentStatusId,
      'Main_Organisation_Id': mainOrganisationId,
      'Student_No': studentNo,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'Date_Of_Birth': dateOfBirth,
      'Address': address,
      'Telephone_No': telephoneNo,
      'PrimaryContactNo': primaryContactNo,
      'Gender_Id': genderId,
      'City': city,
      'State': state,
      'Country': country,
      'Postal_Code': postalCode,
      'Comments': comments,
      'Region_Id': regionId,
      'Center_Id': centerId,
      'Grade_Id': gradeId,
      'Approval_Date': approvalDate,
      'Application_Date': applicationDate,
      'Transfer_Date': transferDate,
      'Drop_Date': dropDate,
      'FatherEmail': fatherEmail,
      'Student_noI': studentNoI,
      'fullname': name,
      'PrevClass': prevClass,
      'ErpClass': erpClass,
      'PromotedTo': promotedTo,
      'Remarks': remarks,
      'Region_Name': region,
      'Center_Name': center,
      'Class_Name': className,
      'TokenId': tokenId,
    };
  }
}
