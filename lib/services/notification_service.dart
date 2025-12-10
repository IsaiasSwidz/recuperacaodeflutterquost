/// Serviço de Notificação - Gerencia notificações locais
/// 
/// Esta classe gerencia todas as notificações locais do aplicativo,
/// incluindo notificações normais e críticas que contornam as configurações
/// de silêncio do dispositivo
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  /// Inicializa o serviço de notificações
  /// 
  /// Configura os canais de notificação para Android e iOS
  /// e solicita as permissões necessárias
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = 
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings = 
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) async {
        // Manipula o toque na notificação
        if (payload.payload != null) {
          // Navega para tela específica com base no payload
        }
      },
    );

    // Solicita permissões
    await Permission.notification.request();
  }

  /// Exibe uma notificação normal
  /// 
  /// Esta notificação segue as configurações padrão do sistema
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'monitoring_channel',
      'Monitoring Alerts',
      channelDescription: 'Canal para notificações de monitoramento e alertas',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList(const [0, 1000, 500, 1000]),
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics = 
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Exibe uma notificação crítica
  /// 
  /// Esta notificação tenta contornar as configurações de silêncio
  /// e modo Não Perturbe para garantir entrega imediata
  static Future<void> showCriticalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'critical_channel',
      'Critical Alerts',
      channelDescription: 'Canal para alertas críticos que requerem atenção imediata',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList(const [0, 1000, 500, 1000, 500, 1000]),
      fullScreenIntent: true, // Mostra notificação como intent de tela cheia
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics = 
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'critical_alert.aiff', // Som crítico personalizado
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notifications.show(
      1,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}