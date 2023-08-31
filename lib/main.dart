import 'dart:async';
import 'package:deep_linking_template/services/notification/one_signal_notification.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum DeepLinkStatus {
  notChecked,
  handled,
  notHandled,
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription? _sub;
  String? initialLink;
  DeepLinkStatus deepLinkStatus = DeepLinkStatus.notChecked;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    OneSignalService().configOneSignal();
    initDeepLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub!.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    try {
      initialLink = await getInitialLink();
      handleDeepLink(initialLink ?? '');
      _sub = linkStream.listen((String? link) {
        debugPrint('Received deep link: $link');
        handleDeepLink(link!);
      });
    } on PlatformException {
      // Handle exception if any
    }
  }

  void handleDeepLink(String? link) {
    if (deepLinkStatus == DeepLinkStatus.handled) {
      return;
    }
    if (link != null) {
      if (link.contains("www.handle-deep-linking.com")) {
//handle logic if link appears
        deepLinkStatus = DeepLinkStatus.handled;
      }
    }

    deepLinkStatus = DeepLinkStatus.notHandled;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed &&
        deepLinkStatus == DeepLinkStatus.notChecked) {
      handleDeepLink(initialLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Handle Deep Linking",
      home: HandleDeepLinkWidget(
        deepLinkStatusString: deepLinkStatus.toString(),
        link: initialLink,
      ),
    );
  }
}

class HandleDeepLinkWidget extends StatelessWidget {
  String? deepLinkStatusString;
  String? link;

  HandleDeepLinkWidget({
    this.deepLinkStatusString,
    this.link,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          child: Text(
            "status=====>${deepLinkStatusString}\nlink=====>${link}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
