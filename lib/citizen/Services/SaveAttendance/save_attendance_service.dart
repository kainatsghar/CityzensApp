import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';
import 'package:tcs_app/citizen/Model/StudentAttendance/save_attendance_request.dart';

class SaveAttendanceService {
  static Future<ResponseMessage> saveAttendanceRequest(
      SaveAttendanceRequest saveAttendanceRequest) async {
    var response = await ApiBaseHelper.httpPostRequest("SaveAttendance",
        body: saveAttendanceRequest.toJson());
    // ignore: avoid_print
    //print(saveAttendanceRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}
