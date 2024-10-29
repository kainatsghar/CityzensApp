class StudentProfileResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  List<Profile>? profile;

  StudentProfileResponse(
      {this.isSuccessful, this.message, this.isException, this.profile});

  factory StudentProfileResponse.fromJson(Map json) {
    var list = json['profile']as List;
    List<Profile> profileList = list.map((i) => Profile.fromJson(i)).toList();
    return StudentProfileResponse(
        isSuccessful: json['IsSuccessful'],
        message: json['Message'],
        isException: json['IsServerException'],
        profile: profileList);
  }
}

class Profile {
  int? studentId;
  String? name;
  String? dateOfBirth;
  String? address;
  String? contactNo;
  String? city;
  String? fatherEmail;
  String? region;
  String? center;
  String? className;

  Profile(
      {this.studentId,
      this.name,
      this.dateOfBirth,
      this.address,
      this.contactNo,
      this.city,
      this.fatherEmail,
      this.region,
      this.center,
      this.className});

  factory Profile.fromJson(Map json) {
    return Profile(
      studentId: json['Student_Id'],
      name: json['fullname'],
      dateOfBirth: json['Date_Of_Birth'],
      address: json['Address'],
      contactNo: json['Telephone_No'],
      city: json['City'],
      className: json['Class_Name'],
      center: json['Center_Name'],
      region: json['Region_Name'],
      fatherEmail: json['FatherEmail'],
    );
  }
}
