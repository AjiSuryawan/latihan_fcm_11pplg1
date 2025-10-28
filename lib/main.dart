import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = "Waiting for messages...";
  String _token = "";

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    // Request notification permission (especially needed on iOS and Android 13+)
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission();
    print('🔔 User granted permission: ${settings.authorizationStatus}');

    // Get the FCM token (you’ll need this to send notifications)
    String? token = await FirebaseMessaging.instance.getToken();
    print('📱 FCM Token: $token');

    setState(() {
      _token = token ?? "No token";
    });

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Received foreground message: ${message.notification?.title}');
      setState(() {
        _message =
            "${message.notification?.title ?? "No title"}\n${message.notification?.body ?? "No body"}";
      });
    });

    // When notification is tapped from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification clicked!');
      setState(() {
        _message =
            "Opened from background: ${message.notification?.title ?? "No title"}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FCM Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Firebase Cloud Messaging")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Last message received:"),
              const SizedBox(height: 10),
              Text(_message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                "Your FCM Token:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(_token, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
