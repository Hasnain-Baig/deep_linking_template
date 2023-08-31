import 'dart:convert';

import 'package:deep_linking_template/services/api/api_services.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:dio/dio.dart';

class OneSignalService {
  void configOneSignal() async {
    //insert id here all notification will work i have tested it
    await OneSignal.shared.setAppId("APP_ID");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  }
}

sendNotification(String externalUserId, String message) async {
  try {
    var url = "https://onesignal.com/api/v1/notifications";
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "ONE_SIGNAL_AUTH_KEY", //from one signal auth key
    };
    var body = {
      "app_id": "APP_ID",
      "contents": {"en": message},
      "include_external_user_ids": [externalUserId],
    };

    var response = await ApiServices()
        .postReq(endPoint: url, headers: headers, data: body);

    if (response.statusCode == 200) {
      debugPrint("OneSignal Notification sent successfully to $externalUserId");
      return 1;
    } else {
      debugPrint("Error sending notification: ${response.statusCode}");
      return 0;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
