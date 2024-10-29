import '../../Model/Appointment/Appointment_request.dart';
import '../../Model/Appointment/appointment_response.dart';
import '../../Network/api_base_helper.dart';

class AppointmentService {
  static Future<MeetingResponse> getMeetings(
      {required int userName, required bool isStudent}) async {
    AppointmentRequest request =
        AppointmentRequest(id: userName, isStudent: isStudent);
    var response = await ApiBaseHelper.httpPostRequest("GetMeetings",
        body: request.toJson());
    return MeetingResponse.fromJson(response);
  }
}
