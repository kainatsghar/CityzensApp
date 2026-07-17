import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:tcs_app/model/StudentSubjects/student_subject_response.dart';
import 'package:tcs_app/utils/app_constants.dart';

class StudentSubjectService {
  static Future<StudentSubjectResponse> getSubjects({
    required String studentId,
    required String tokenId,
    required int sessionId,
  }) async {
    final Map<String, dynamic> body = {
      "id": studentId,
      "tokenId": tokenId,
      "Session_Id": sessionId,
    };

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseURL}SearchStudentSubjectList'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      log('SearchStudentSubjectList Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return StudentSubjectResponse.fromJson(json.decode(response.body));
      } else {
        log('SearchStudentSubjectList Error: ${response.statusCode}');
        return StudentSubjectResponse(isSuccessful: false, message: 'Server Error');
      }
    } catch (e) {
      log('SearchStudentSubjectList Exception: $e');
      return StudentSubjectResponse(isSuccessful: false, message: e.toString());
    }
  }
}
