import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/TeacherActions/delete_action_request.dart';
import 'package:tcs_app/model/TeacherActions/update_announcement_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

import '../../model/CircularAnnouncement/circular_announcement_request.dart';
import '../../model/CircularAnnouncement/circular_announcement_response.dart';

class CircularAnnouncementService {
  static Future<CircularAnnouncementResponse> getCircularAnnouncement({
    required String classTeacherId,
    required String tokenId,
  }) async {
    CircularAnnouncementRequest request = CircularAnnouncementRequest(
      classTeacherId: classTeacherId,
      tokenId: tokenId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetCircularAnnouncementOfTeacher",
      body: request.toJson(),
    );
    return CircularAnnouncementResponse.fromJson(response);
  }

  static Future<ResponseMessage> updateAnnouncement(
    UpdateAnnouncementRequest request,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "UpdateAnnouncement",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }

  static Future<ResponseMessage> deleteAnnouncement(
    DeleteActionRequest request,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "DeleteAnnouncement",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}
