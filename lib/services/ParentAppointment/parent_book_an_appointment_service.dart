import '../../model/Appointment/Appointment_request.dart';
import '../../model/Appointment/appointment_response.dart';
import '../../network/api_base_helper.dart';

class ParentBookanAppointmentService {
  static Future<AppointmentResponse> getMeetingConfig({
    required int userName,
    required String? tokenId,
  }) async {
    AppointmentRequest request = AppointmentRequest(
      id: userName,
      tokenId: tokenId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetMeetingConfig",
      body: request.toJson(),
    );
    return AppointmentResponse.fromJson(response);
  }
}
