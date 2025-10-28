import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  var lastMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initFCM();
  }

  void _initFCM() async {
    // Minta izin untuk notifikasi
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Dapatkan token device
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Listener saat app aktif
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in foreground: ${message.notification?.title}');
      lastMessage.value =
          '${message.notification?.title ?? ''}\n${message.notification?.body ?? ''}';
    });

    // Listener saat notifikasi diklik (terminated atau background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      lastMessage.value =
          'Opened: ${message.notification?.title ?? ''}\n${message.notification?.body ?? ''}';
    });
  }
}
