import 'package:flutter_test/flutter_test.dart';
import '../lib/data/models/alert_model.dart';
import '../lib/data/models/preferences_model.dart';

void main() {
  group('Teste 1: Conversão de Modelos', () {
    test('AlertModel toMap() e fromMap() devem funcionar corretamente', () {
      // Criar um modelo
      final originalAlert = AlertModel(
        id: 1,
        type: 'Emergency',
        triggerTime: DateTime(2025, 12, 9, 14, 30, 0),
        processedTime: DateTime(2025, 12, 9, 14, 35, 0),
        isCritical: true, description: '',
      );
      
      // Converter para mapa
      final map = originalAlert.toMap();
      
      // Verificar o mapa
      expect(map['id'], equals(1));
      expect(map['type'], equals('Emergency'));
      expect(map['isCritical'], equals(1));
      
      // Converter de volta
      final restoredAlert = AlertModel.fromMap(map);
      
      // Verificar se os dados são os mesmos
      expect(restoredAlert.id, equals(1));
      expect(restoredAlert.type, equals('Emergency'));
      expect(restoredAlert.isCritical, equals(true));
      expect(restoredAlert.triggerTime.year, equals(2025));
      expect(restoredAlert.triggerTime.month, equals(12));
      expect(restoredAlert.triggerTime.day, equals(9));
    });
    
    test('AlertModel sem processedTime', () {
      final alert = AlertModel(
        type: 'Immediate Alert',
        triggerTime: DateTime.now(), description: '',
      );
      
      final map = alert.toMap();
      expect(map['processedTime'], isNull);
      
      final restored = AlertModel.fromMap(map);
      expect(restored.processedTime, isNull);
    });
  });
  
  group('Teste 2: Preferências do Usuário', () {
    test('PreferencesModel deve serializar corretamente', () {
      final prefs = PreferencesModel(
        vibrationEnabled: true,
        soundEnabled: false,
        bannerEnabled: true,
        criticalMode: true,
      );
      
      final map = prefs.toMap();
      
      expect(map['vibrationEnabled'], equals(true));
      expect(map['soundEnabled'], equals(false));
      expect(map['bannerEnabled'], equals(true));
      expect(map['criticalMode'], equals(true));
    });
    
    test('PreferencesModel com valores padrão', () {
      final defaultPrefs = PreferencesModel();
      
      expect(defaultPrefs.vibrationEnabled, equals(true));
      expect(defaultPrefs.soundEnabled, equals(true));
      expect(defaultPrefs.bannerEnabled, equals(true));
      expect(defaultPrefs.criticalMode, equals(false));
    });
    
    test('PreferencesModel fromMap com valores nulos', () {
      final map = {
        'vibrationEnabled': null,
        'soundEnabled': true,
        'criticalMode': false,
      };
      
      final prefs = PreferencesModel.fromMap(map);
      
      // Valores nulos devem usar padrão
      expect(prefs.vibrationEnabled, equals(true)); // Padrão quando null
      expect(prefs.soundEnabled, equals(true));
      expect(prefs.bannerEnabled, equals(true)); // Padrão quando não especificado
      expect(prefs.criticalMode, equals(false));
    });
  });
  
  group('Teste 3: Lógica de Alerta', () {
    test('Alertas críticos devem ter isCritical = true', () {
      final criticalAlert = AlertModel(
        type: 'Critical System Failure',
        triggerTime: DateTime.now(),
        isCritical: true, description: '',
      );
      
      expect(criticalAlert.isCritical, equals(true));
      
      final map = criticalAlert.toMap();
      expect(map['isCritical'], equals(1)); // 1 representa true no banco
    });
    
    test('Alertas normais devem ter isCritical = false por padrão', () {
      final normalAlert = AlertModel(
        type: 'System Check',
        triggerTime: DateTime.now(), description: '',
      );
      
      expect(normalAlert.isCritical, equals(false));
      
      final map = normalAlert.toMap();
      expect(map['isCritical'], equals(0)); // 0 representa false no banco
    });
  });
}