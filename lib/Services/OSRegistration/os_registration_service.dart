import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tcs_app/Model/OSRegistration/os_registration_request.dart';
import 'package:tcs_app/Model/OSRegistration/os_registration_response.dart';
import 'package:tcs_app/Model/ResponseMessage/response_message.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class OSRegistrationService {
  static Future<List<OSRegistrationResponse>> osInfoRequest(
      {String endpoint, UserDataRequest body}) async {
    var response =
        await ApiBaseHelper.httpPostRequest("OSR/$endpoint", body: body);
    List<OSRegistrationResponse> listResponse =
        listFromJson(json.encode(response));
    return listResponse;
  }

  static Future<ResponseMessage> osRegistrationRequest(
      {@required OSRegistrationRequest registrationRequest}) async {
    var response = await ApiBaseHelper.httpPostRequest("OSR/AddRegistration",
        body: registrationRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}
