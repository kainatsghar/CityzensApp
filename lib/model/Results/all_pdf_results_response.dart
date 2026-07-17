class AllPDFResultsResponse {
  final bool isSuccessful;
  final String message;
  final bool isServerException;
  final List<PDFResultItem> pdfResults;

  AllPDFResultsResponse({
    required this.isSuccessful,
    required this.message,
    required this.isServerException,
    required this.pdfResults,
  });

  factory AllPDFResultsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['PDFResults'] as List? ?? [];
    List<PDFResultItem> items = list
        .map((i) => PDFResultItem.fromJson(Map<String, dynamic>.from(i)))
        .toList();

    return AllPDFResultsResponse(
      isSuccessful: json['IsSuccessful'] ?? false,
      message: json['Message'] ?? '',
      isServerException: json['IsServerException'] ?? false,
      pdfResults: items,
    );
  }
}

class PDFResultItem {
  final int? regionId;
  final String? regionName;
  final int? centerId;
  final String? centerName;
  final int? classId;
  final String? className;
  final int? sectionId;
  final String? sectionName;
  final int? studentId;
  final String? fullname;
  final bool? isFeeDefaulter;
  final int? subjects;
  final int? absents;
  final String? studentStatus;
  final String? mobileNo;
  final String? sms;
  final bool? isSMSSent;
  final String? url;
  /// Direct PDF download URL when backend provides one (`PDFURL`).
  final String? pdfUrl;
  /// Stable document id for cache keys when backend provides one (`Document_Id`).
  final String? documentId;
  final int? records;
  final int? sendSMS;
  final String? smsDate;
  final String? fatherEmail;
  final int? sessionId;
  final int? termGroupId;
  final String? reason;
  final String? message;

  PDFResultItem({
    this.regionId,
    this.regionName,
    this.centerId,
    this.centerName,
    this.classId,
    this.className,
    this.sectionId,
    this.sectionName,
    this.studentId,
    this.fullname,
    this.isFeeDefaulter,
    this.subjects,
    this.absents,
    this.studentStatus,
    this.mobileNo,
    this.sms,
    this.isSMSSent,
    this.url,
    this.pdfUrl,
    this.documentId,
    this.records,
    this.sendSMS,
    this.smsDate,
    this.fatherEmail,
    this.sessionId,
    this.termGroupId,
    this.reason,
    this.message,
  });

  factory PDFResultItem.fromJson(Map<String, dynamic> json) {
    return PDFResultItem(
      regionId: json['Region_Id'],
      regionName: json['Region_Name'],
      centerId: json['Center_Id'],
      centerName: json['Center_Name'],
      classId: json['Class_Id'],
      className: json['Class_Name'],
      sectionId: json['Section_Id'],
      sectionName: json['Section_Name'],
      studentId: json['Student_Id'],
      fullname: json['fullname'],
      isFeeDefaulter: json['isFeeDefaulter'],
      subjects: json['Subjects'],
      absents: json['Absents'],
      studentStatus: json['StudentStatus'],
      mobileNo: json['MobileNo'],
      sms: json['SMS'],
      isSMSSent: json['isSMSSent'],
      url: json['URL'],
      pdfUrl: json['PDFURL'] ?? json['DownloadUrl'] ?? json['PdfUrl'],
      documentId: json['Document_Id']?.toString() ??
          json['ResultDocumentId']?.toString(),
      records: json['Records'],
      sendSMS: json['SendSMS'],
      smsDate: json['SMSDate'],
      fatherEmail: json['FatherEmail'],
      sessionId: json['Session_Id'],
      termGroupId: json['TermGroup_Id'],
      reason: json['Reason'],
      message: json['Message'],
    );
  }

  /// Extracts a readable term/session title from the SMS or Message (e.g. "Second Term Exam 2024-2025")
  String get displayName {
    for (final text in [sms, message]) {
      if (text != null && text.isNotEmpty) {
        // Strip HTML tags if present (e.g., <br>)
        final cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '');
        final startPhrase = "child's ";
        final startIndex = cleanText.indexOf(startPhrase);
        if (startIndex != -1) {
          final contentStart = startIndex + startPhrase.length;
          final endIndex = cleanText.indexOf('.', contentStart);
          if (endIndex != -1) {
            return cleanText.substring(contentStart, endIndex).trim();
          }
        }
      }
    }
    final termName = termGroupId == 1
        ? "First Term"
        : (termGroupId == 2 ? "Second Term" : "Term $termGroupId");
    final sessionLabel = sessionId != null ? "Session $sessionId" : "";
    final classLabel = className ?? "";
    return "$classLabel - $termName $sessionLabel".trim();
  }
}
