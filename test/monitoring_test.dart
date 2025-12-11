import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/data/models/alert_model.dart';
import '../lib/data/models/preferences_model.dart';

void main() {
  group('Model Tests', () {
    test('AlertModel toMap and fromMap conversion', () {
      final alert = AlertModel(
        id: 1,
        type: 'Test Alert',
        triggerTime: DateTime(2025, 12, 9, 10, 30, 0),
        processedTime: DateTime(2025, 12, 9, 10, 35, 0),
        isCritical: true,
      );
      
      final map = alert.toMap();
      final restoredAlert = AlertModel.fromMap(map);
      
      expect(restoredAlert.type, equals('Test Alert'));
      expect(restoredAlert.isCritical, equals(true));
      expect(restoredAlert.triggerTime.year, equals(2025));
    });
    
    test('AlertModel without processedTime', () {
      final alert = AlertModel(
        type: 'Immediate Alert',
        triggerTime: DateTime.now(),
        isCritical: false,
      );
      
      final map = alert.toMap();
      final restoredAlert = AlertModel.fromMap(map);
      
      expect(restoredAlert.type, equals('Immediate Alert'));
      expect(restoredAlert.processedTime, isNull);
      expect(restoredAlert.isCritical, equals(false));
    });
    
    test('PreferencesModel serialization/deserialization', () {
      final prefs = PreferencesModel(
        vibrationEnabled: true,
        soundEnabled: false,
        bannerEnabled: true,
        criticalMode: true,
      );
      
      final map = prefs.toMap();
      final restoredPrefs = PreferencesModel.fromMap(map);
      
      expect(restoredPrefs.vibrationEnabled, equals(true));
      expect(restoredPrefs.soundEnabled, equals(false));
      expect(restoredPrefs.bannerEnabled, equals(true));
      expect(restoredPrefs.criticalMode, equals(true));
    });
    
    test('PreferencesModel default values', () {
      final defaultPrefs = PreferencesModel();
      
      expect(defaultPrefs.vibrationEnabled, equals(true));
      expect(defaultPrefs.soundEnabled, equals(true));
      expect(defaultPrefs.bannerEnabled, equals(true));
      expect(defaultPrefs.criticalMode, equals(false));
    });
  });
  
  group('Alert Logic Tests', () {
    test('Alert trigger time should be in the past or present', () {
      final now = DateTime.now();
      final alert = AlertModel(
        type: 'Test',
        triggerTime: now,
        isCritical: false,
      );
      
      expect(alert.triggerTime.isBefore(now.add(Duration(seconds: 1))), equals(true));
      expect(alert.triggerTime.isAfter(now.subtract(Duration(seconds: 1))), equals(true));
    });
    
    test('Critical alert should have isCritical true', () {
      final alert = AlertModel(
        type: 'Critical Alert',
        triggerTime: DateTime.now(),
        isCritical: true,
      );
      
      expect(alert.isCritical, equals(true));
    });
  });
  
  group('Preferences Logic Tests', () {
    test('Preferences should be mutable', () {
      final prefs = PreferencesModel();
      
      // Test mutability
      prefs.vibrationEnabled = false;
      prefs.soundEnabled = false;
      prefs.bannerEnabled = false;
      prefs.criticalMode = true;
      
      expect(prefs.vibrationEnabled, equals(false));
      expect(prefs.soundEnabled, equals(false));
      expect(prefs.bannerEnabled, equals(false));
      expect(prefs.criticalMode, equals(true));
    });
    
    test('Preferences map conversion with null values', () {
      final map = {
        'vibrationEnabled': null,
        'soundEnabled': true,
        'bannerEnabled': null,
        'criticalMode': false,
      };
      
      final prefs = PreferencesModel.fromMap(map);
      
      expect(prefs.vibrationEnabled, equals(true)); // Default when null
      expect(prefs.soundEnabled, equals(true));
      expect(prefs.bannerEnabled, equals(true)); // Default when null
      expect(prefs.criticalMode, equals(false));
    });
  });
}