import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/model/StudentAttendance/save_attendance_request.dart';

class SaveAttendanceService {
  static Future<ResponseMessage> saveAttendanceRequest(
      SaveAttendanceRequest saveAttendanceRequest) async {
    print(saveAttendanceRequest.toJson());
    var response = await ApiBaseHelper.httpPostRequest("SaveAttendance",
        body: saveAttendanceRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}
