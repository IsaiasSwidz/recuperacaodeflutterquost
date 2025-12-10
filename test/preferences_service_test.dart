/// Testes do Serviço de Preferências
/// 
/// Esta suíte de testes verifica a funcionalidade do serviço de preferências,
/// incluindo inicialização, alternância de configurações e persistência
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/services/preferences_service.dart';
import '../lib/models/preferences.dart';

void main() {
  group('Testes do Serviço de Preferências', () {
    setUp(() {
      // Inicializa SharedPreferences com uma implementação mock
      SharedPreferences.setMockInitialValues({});
    });

    test('deve inicializar com preferências padrão', () async {
      final service = PreferencesService();
      
      // Aguarda inicialização
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(service.preferences.vibrationEnabled, true);
      expect(service.preferences.soundEnabled, true);
      expect(service.preferences.bannerEnabled, true);
      expect(service.preferences.criticalMode, false);
    });

    test('deve alternar preferência de vibração', () async {
      final service = PreferencesService();
      
      // Aguarda inicialização
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Inicialmente verdadeiro
      expect(service.preferences.vibrationEnabled, true);
      
      // Alterna para falso
      await service.toggleVibration();
      expect(service.preferences.vibrationEnabled, false);
      
      // Alterna de volta para verdadeiro
      await service.toggleVibration();
      expect(service.preferences.vibrationEnabled, true);
    });

    test('deve alternar preferência de som', () async {
      final service = PreferencesService();
      
      // Aguarda inicialização
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Inicialmente verdadeiro
      expect(service.preferences.soundEnabled, true);
      
      // Alterna para falso
      await service.toggleSound();
      expect(service.preferences.soundEnabled, false);
      
      // Alterna de volta para verdadeiro
      await service.toggleSound();
      expect(service.preferences.soundEnabled, true);
    });

    test('deve alternar modo crítico', () async {
      final service = PreferencesService();
      
      // Aguarda inicialização
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Inicialmente falso
      expect(service.preferences.criticalMode, false);
      
      // Alterna para verdadeiro
      await service.toggleCriticalMode();
      expect(service.preferences.criticalMode, true);
      
      // Alterna de volta para falso
      await service.toggleCriticalMode();
      expect(service.preferences.criticalMode, false);
    });

    test('deve salvar preferências corretamente', () async {
      final service = PreferencesService();
      
      // Aguarda inicialização
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Cria novas preferências
      final newPrefs = Preferences(
        vibrationEnabled: false,
        soundEnabled: false,
        bannerEnabled: false,
        criticalMode: true,
      );
      
      // Salva as novas preferências
      await service.savePreferences(newPrefs);
      
      // Verifica que as preferências foram atualizadas
      expect(service.preferences.vibrationEnabled, false);
      expect(service.preferences.soundEnabled, false);
      expect(service.preferences.bannerEnabled, false);
      expect(service.preferences.criticalMode, true);
    });
  });
}