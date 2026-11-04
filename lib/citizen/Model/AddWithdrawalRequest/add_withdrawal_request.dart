class AddWithdrawalRequest {
  String? reasonId;
  int? studentId;
  String? userId;
  bool? isRelocated;
  String? townCity;
  String? specify;
  String? createdBy;

  bool? isContactedBySchool;
  bool? isSatisfiedConcerns;
  bool? isWithdrawal;
  String? inFavourOf;
  String? address;

  AddWithdrawalRequest(
      {this.reasonId,
      this.studentId,
      this.userId,
      this.isRelocated,
      this.townCity,
      this.specify,
      this.createdBy,
      this.isContactedBySchool,
      this.isSatisfiedConcerns,
      this.isWithdrawal,
      this.inFavourOf,
      this.address});

  AddWithdrawalRequest.fromJson(Map<String, dynamic> json) {
    reasonId = json['reasonId'];
    studentId = json['studentId'];
    userId = json['userId'];
    isRelocated = json['isRelocated'];
    townCity = json['townCity'];
    specify = json['specify'];
    createdBy = json['createdBy'];

    isContactedBySchool = json['isContactedBySchool'];
    isSatisfiedConcerns = json['isSatisfiedConcerns'];
    isWithdrawal = json['isWithdrawal'];
    inFavourOf = json['inFavourOf'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reasonId'] = reasonId;
    data['studentId'] = studentId;
    data['userId'] = userId;
    data['isRelocated'] = isRelocated;
    data['townCity'] = townCity;
    data['specify'] = specify;
    data['createdBy'] = createdBy;

    data['isContactedBySchool'] = isContactedBySchool;
    data['isSatisfiedConcerns'] = isSatisfiedConcerns;
    data['isWithdrawal'] = isWithdrawal;
    data['inFavourOf'] = inFavourOf;
    data['address'] = address;

    return data;
  }
}
