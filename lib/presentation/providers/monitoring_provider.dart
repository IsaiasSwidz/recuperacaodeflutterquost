import 'package:flutter/material.dart';
import '../../data/models/alert_model.dart';
import '../../data/models/preferences_model.dart';
import '../../services/database/database_service.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/api/api_service.dart';

class MonitoringProvider with ChangeNotifier {
  bool _isSystemActive = true;
  List<AlertModel> _alerts = [];
  PreferencesModel _preferences = PreferencesModel();
  
  bool get isSystemActive => _isSystemActive;
  List<AlertModel> get alerts => _alerts;
  PreferencesModel get preferences => _preferences;
  
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  final ApiService _apiService = ApiService();
  
  MonitoringProvider() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    await _notificationService.initialize();
    await loadPreferences();
    await loadAlerts();
  }
  
  Future<void> loadPreferences() async {
    // Implementar carregamento do SharedPreferences
    notifyListeners();
  }
  
  Future<void> savePreferences() async {
    // Implementar salvamento no SharedPreferences
    notifyListeners();
  }
  
  Future<void> loadAlerts() async {
    _alerts = await _databaseService.getAlerts();
    notifyListeners();
  }
  
  Future<void> triggerAlert(String type) async {
    final alert = AlertModel(
      type: type,
      triggerTime: DateTime.now(),
      isCritical: _preferences.criticalMode, description: '',
    );
    
    // Salvar no banco local
    await _databaseService.insertAlert(alert);
    
    // Enviar para API
    try {
      await _apiService.sendAlert(type);
    } catch (e) {
      print('Failed to send to API: $e');
    }
    
    // Disparar notificação
    await _notificationService.showAlertNotification(
      title: 'Alerta Disparado!',
      body: 'Tipo: $type - ${DateTime.now().toString()}',
      sound: _preferences.soundEnabled,
      vibration: _preferences.vibrationEnabled,
      critical: _preferences.criticalMode,
    );
    
    // Atualizar lista local
    await loadAlerts();
  }
  
  // Setters para preferências
  void setVibrationEnabled(bool value) {
    _preferences.vibrationEnabled = value;
    savePreferences();
  }
  
  void setSoundEnabled(bool value) {
    _preferences.soundEnabled = value;
    savePreferences();
  }
  
  void setBannerEnabled(bool value) {
    _preferences.bannerEnabled = value;
    savePreferences();
  }
  
  void setCriticalMode(bool value) {
    _preferences.criticalMode = value;
    savePreferences();
  }
  
  void toggleSystem() {
    _isSystemActive = !_isSystemActive;
    notifyListeners();
  }
}