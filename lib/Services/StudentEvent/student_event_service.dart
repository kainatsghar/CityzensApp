import 'package:tcs_app/Model/SchoolEvents/school_events_request.dart';
import 'package:tcs_app/Model/SchoolEvents/school_events_response.dart';

import '../../network/api_base_helper.dart';

class StudentEventService {
  static Future<SchoolEeventsResponse> getEventRecords({
    required int id,
  }) async {
    SchoolEventRequest request = SchoolEventRequest(id: id);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetEventCalender",
      body: request.toJson(),
    );
    return SchoolEeventsResponse.fromJson(response);
  }
}
