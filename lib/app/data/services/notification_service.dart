// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz_data;

// class NotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeTimezone();
//     _initializeLocalNotifications();
//     _initializeFirebaseMessaging();
//   }
  
//   void _initializeTimezone() {
//     tz_data.initializeTimeZones();
//   }
  
//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings androidInitSettings = 
//         AndroidInitializationSettings('@mipmap/ic_launcher');
    
//     const InitializationSettings initSettings = 
//         InitializationSettings(android: androidInitSettings);
    
//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         // Handle notification tap
//         final payload = details.payload;
//         if (payload != null) {
//           _handleNotificationTap(payload);
//         }
//       },
//     );
    
//     // Request permissions
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//   }
  
//   Future<void> _initializeFirebaseMessaging() async {
//     // Request permission
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
    
//     // Get FCM token
//     final token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
    
//     // Configure handlers
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
    
//     // Check for initial message (if app was opened from a terminated state)
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _handleBackgroundMessageTap(initialMessage);
//     }
//   }
  
//   void _handleForegroundMessage(RemoteMessage message) {
//     print('Foreground message received: ${message.notification?.title}');
    
//     // Show local notification
//     if (message.notification != null) {
//       showNotification(
//         title: message.notification!.title ?? 'Solo Hunter',
//         body: message.notification!.body ?? '',
//         payload: message.data['route'] ?? '',
//       );
//     }
//   }
  
//   void _handleBackgroundMessageTap(RemoteMessage message) {
//     print('Background message tapped: ${message.notification?.title}');
    
//     final route = message.data['route'];
//     if (route != null && route.isNotEmpty) {
//       Get.toNamed(route);
//     }
//   }
  
//   void _handleNotificationTap(String payload) {
//     print('Notification tapped with payload: $payload');
    
//     if (payload.isNotEmpty) {
//       Get.toNamed(payload);
//     }
//   }
  
//   // Show a notification
//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String payload = '',
//     int id = 0,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'solo_leveling_channel',
//       'Solo Leveling Notifications',
//       channelDescription: 'Notifications for Solo Leveling Fitness App',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//     );
    
//     const NotificationDetails details = 
//         NotificationDetails(android: androidDetails);
    
//     await _localNotifications.show(
//       id,
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }
  
//   // Schedule a notification
//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     String payload = '',
//     int id = 0,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'solo_leveling_channel',
//       'Solo Leveling Notifications',
//       channelDescription: 'Notifications for Solo Leveling Fitness App',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//     );
    
//     const NotificationDetails details = 
//         NotificationDetails(android: androidDetails);
    
//     await _localNotifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       details,
//       payload: payload,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: 
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
  
//   // Schedule daily reminder at 7 AM
//   Future<void> scheduleDailyReminder() async {
//     final now = DateTime.now();
//     DateTime scheduledTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       7, // 7 AM
//       0,
//     );
    
//     // If current time is after 7 AM, schedule for tomorrow
//     if (now.hour >= 7) {
//       scheduledTime = scheduledTime.add(Duration(days: 1));
//     }
    
//     await scheduleNotification(
//       title: 'Your quests await, Hunter',
//       body: 'Complete your daily tasks and grow stronger!',
//       scheduledTime: scheduledTime,
//       payload: '/home',
//       id: 1, // Use consistent ID to replace existing reminder
//     );
//   }
  
//   // Show death notification
//   Future<void> showDeathNotification() async {
//     await showNotification(
//       title: 'You have died!',
//       body: 'You failed your mission. Use a Black Heart to revive or start over.',
//       payload: '/death',
//       id: 2,
//     );
//   }
  
//   // Show level up notification
//   Future<void> showLevelUpNotification(int level) async {
//     await showNotification(
//       title: 'Level Up!',
//       body: 'Congratulations, you have reached Level $level!',
//       payload: '/profile',
//       id: 3,
//     );
//   }
  
//   // Show class upgrade notification
//   Future<void> showClassUpgradeNotification(String playerClass) async {
//     await showNotification(
//       title: 'Class Upgrade!',
//       body: 'You have been promoted to $playerClass-Class Hunter!',
//       payload: '/profile',
//       id: 4,
//     );
//   }
// }