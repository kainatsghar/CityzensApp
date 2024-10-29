import '../../Model/AddAppointment/add_appointment_request.dart';
import '../../Network/api_base_helper.dart';
import '../../model/ResponseMessage/response_message.dart';

class AddAppointmentService {
  static Future<ResponseMessage> addAppointment(
      AddAppointmentRequest addAppointmentRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "SaveMeeting",
      body: addAppointmentRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}
