class ResultsRequest {
  String? tokenId;
  String? userName;
  int? academicYearId;
  int? termId;

  ResultsRequest(
      {this.tokenId, this.userName, this.academicYearId, this.termId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userName;
    data['tokenId'] = tokenId;
    data['session_Id'] = academicYearId;
    data['termGroup_Id'] = termId;
    return data;
  }
}
