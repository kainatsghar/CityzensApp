import 'package:tcs_app/model/SchoolEvents/school_events_request.dart';
import 'package:tcs_app/model/SchoolEvents/school_events_response.dart';

import '../../network/api_base_helper.dart';

class TeacherEventService {
  static Future<SchoolEeventsResponse> getEventRecords({
    required int id,
    required bool isStudent,
  }) async {
    SchoolEventRequest request = SchoolEventRequest(
      id: id,
      isStudent: isStudent,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetEventCalender",
      body: request.toJson(),
    );
    return SchoolEeventsResponse.fromJson(response);
  }
}
