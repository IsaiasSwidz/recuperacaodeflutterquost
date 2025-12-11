import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  
  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  
  NotificationService._internal();
  
  Future<void> initialize() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);
    
    await _notificationsPlugin.initialize(initializationSettings);
  }
  
  Future<void> showAlertNotification({
    required String title,
    required String body,
    bool sound = true,
    bool vibration = true,
    bool critical = false,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alert_channel',
      'Alertas',
      channelDescription: 'Canal para alertas de emergência',
      importance: Importance.max,
      priority: Priority.high,
      sound: sound ? const RawResourceAndroidNotificationSound('alarm') : null,
      enableVibration: vibration,
      channelShowBadge: true,
      playSound: sound,
      timeoutAfter: critical ? null : 5000,
    );
    
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
  
  Future<void> showCriticalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'critical_channel',
      'Alertas Críticos',
      channelDescription: 'Canal para alertas críticos de emergência',
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('alarm'),
      enableVibration: true,
      channelShowBadge: true,
      playSound: true,
      timeoutAfter: null, // Não expira
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _notificationsPlugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}