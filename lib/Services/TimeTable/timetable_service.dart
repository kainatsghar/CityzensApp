import 'package:tcs_app/network/api_base_helper.dart';
import '../../Model/TimeTable/timetable_request.dart';
import '../../Model/TimeTable/timetable_response.dart';

class TimeTableService {
  static Future<TimeTableResponse> getTimeTableRecords({
    required int? classSectionId,
    required int id,
    required bool isTeacher,
  }) async {
    TimeTableRequest request = TimeTableRequest(
      classSectionId: classSectionId,
      id: id,
      isTeacher: isTeacher,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetClassTimeTable",
      body: request.toJson(),
    );
    return TimeTableResponse.fromJson(response);
  }
}
