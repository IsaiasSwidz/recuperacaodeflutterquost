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
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Abrir app quando notificação for clicada
      },
    );
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
      importance: Importance.max,
      priority: Priority.high,
      sound: sound ? const RawResourceAndroidNotificationSound('alarm') : null,
      enableVibration: vibration,
      channelShowBadge: true,
      playSound: sound,
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
}