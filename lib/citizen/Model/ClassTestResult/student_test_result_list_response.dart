class StudentTestResultListResponse {
  final List<SubjectDto>? subjectDto;
  final bool? isSuccessful;
  final String? message;
  final bool? isServerException;

  StudentTestResultListResponse({
    this.subjectDto,
    this.isSuccessful,
    this.message,
    this.isServerException,
  });

  factory StudentTestResultListResponse.fromJson(Map<String, dynamic> json) {
    return StudentTestResultListResponse(
      subjectDto: List<SubjectDto>.from(
          json["subjectDto"].map((x) => SubjectDto.fromJson(x))),
      isSuccessful: json["IsSuccessful"],
      message: json["Message"],
      isServerException: json["IsServerException"],
    );
  }
}

class SubjectDto {
  final int? subjectId;
  final String? subjectName;
  final List<CategoryDto>? categoryDto;

  SubjectDto({
    this.subjectId,
    this.subjectName,
    this.categoryDto,
  });

  factory SubjectDto.fromJson(Map<String, dynamic> json) {
    return SubjectDto(
      subjectId: json["Subject_Id"],
      subjectName: json["Subject_Name"],
      categoryDto: List<CategoryDto>.from(
          json["CategoryDto"].map((x) => CategoryDto.fromJson(x))),
    );
  }
}

class CategoryDto {
  final int? categoryId;
  final int? obtainedMarks;
  final int? totalMarks;

  CategoryDto({
    this.categoryId,
    this.obtainedMarks,
    this.totalMarks,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      categoryId: json["CategoryId"],
      obtainedMarks: json["ObtainedMarks"],
      totalMarks: json["TotalMarks"],
    );
  }
}
