import 'dart:convert';

import 'package:deep_linking_template/services/api/api_services.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:dio/dio.dart';

import '../shared_prefs/shared_preferences_service.dart';

class OneSignalService {
SharedPreferencesService sps=SharedPreferencesService();
  
  void configOneSignal() async {
    //insert id here all notification will work i have tested it
    await OneSignal.shared.setAppId("APP_ID");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });
    OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  }

  setOneSignalId(String uid) async {
    bool isSetup =
        await sps.getSharedPref("ONE_SIGNAL_SETUP", bool);
    if (!isSetup) {
      debugPrint("Setup OneSignal ID $uid");
      sps.setSharedPref("ONE_SIGNAL_SETUP", true, bool);
      OneSignal.shared.setExternalUserId(uid).then((results) {
        debugPrint("OneSignal ${results.toString()}");
      }).catchError((error) {
        debugPrint("OneSignal ${error.toString()}");
      });
      // OneSignal.shared.setExternalUserId(vendorId);
    } else {
      debugPrint("Already Setup OneSignal ID $uid");
    }
    return true;
  }

sendNotification(String externalUserId, String message) async {
  try {
    var url = "https://onesignal.com/api/v1/notifications";
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "ONE_SIGNAL_REST_API_KEY", //from one signal auth key
    };
    var body = {
      "app_id": "APP_ID",
      "contents": {"en": message},
      "data":{"myData":"whenTapOnNotificationIfNeededToPerformTask"},//(optional)
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




}
