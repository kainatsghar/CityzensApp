import 'package:tcs_app/citizen/Model/AddAppointment/add_appointment_request.dart';
import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';

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
