class StudentListRequest {
  String classSectionId;
  String tokenId;
  String attendanceData;

  StudentListRequest({this.classSectionId, this.tokenId,this.attendanceData});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClassSectionId'] = classSectionId;
    data['TokenId'] = tokenId;
    data['AttendanceDate'] = attendanceData;
    return data;
  }
}