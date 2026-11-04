class AlumniLoginResponse {
  final int? success;
  final String? message;
  final String? unreadCount;
  final AlumniUserModel? user;

  AlumniLoginResponse({
    this.success,
    this.message,
    this.unreadCount,
    this.user,
  });

  bool get isSuccessful => success == 1;

  factory AlumniLoginResponse.fromJson(Map<String, dynamic> json) {
    return AlumniLoginResponse(
      success: json['success'] is int
          ? json['success']
          : int.tryParse(json['success']?.toString() ?? '0'),
      message: json['message']?.toString(),
      unreadCount: json['unread_count']?.toString(),
      user: json['result'] != null && json['result'] is Map<String, dynamic>
          ? AlumniUserModel.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'unread_count': unreadCount,
      'result': user?.toJson(),
    };
  }
}

class AlumniUserModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? token;
  final String? branchId;
  final String? branchName;
  final String? companyId;
  final String? organizationName;
  final String? designation;
  final String? industryName;
  final String? graduationYear;
  final String? image;
  final String? isVerified;
  final String? currentCityName;

  AlumniUserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.token,
    this.branchId,
    this.branchName,
    this.companyId,
    this.organizationName,
    this.designation,
    this.industryName,
    this.graduationYear,
    this.image,
    this.isVerified,
    this.currentCityName,
  });

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final combined = '$first $last'.trim();
    return combined.isEmpty ? 'TCS Alumni' : combined;
  }

  factory AlumniUserModel.fromJson(Map<String, dynamic> json) {
    return AlumniUserModel(
      userId: json['user_id']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      token: json['token']?.toString(),
      branchId: json['branch_id']?.toString(),
      branchName: json['branch_name']?.toString(),
      companyId: json['company_id']?.toString(),
      organizationName: json['organization_name']?.toString(),
      designation: json['designation']?.toString(),
      industryName: json['industry_name']?.toString(),
      graduationYear: json['graduation_year']?.toString(),
      image: json['image']?.toString(),
      isVerified: json['is_verified']?.toString(),
      currentCityName: json['current_city_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'token': token,
      'branch_id': branchId,
      'branch_name': branchName,
      'company_id': companyId,
      'organization_name': organizationName,
      'designation': designation,
      'industry_name': industryName,
      'graduation_year': graduationYear,
      'image': image,
      'is_verified': isVerified,
      'current_city_name': currentCityName,
    };
  }
}

