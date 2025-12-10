/// Serviço de Preferências - Gerencia as configurações do usuário
/// 
/// Esta classe gerencia as preferências do usuário, persistindo-as
/// localmente usando SharedPreferences e notificando os ouvintes
/// quando as preferências são alteradas
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences.dart';

class PreferencesService extends ChangeNotifier {
  static const String _prefsKey = 'app_preferences';
  
  Preferences _preferences = Preferences();

  Preferences get preferences => _preferences;

  PreferencesService() {
    _loadPreferences();
  }

  /// Carrega as preferências do armazenamento local
  /// 
  /// Recupera as preferências salvas anteriormente ou inicializa
  /// com valores padrão se nenhuma preferência existir
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsString = prefs.getString(_prefsKey);
    
    if (prefsString != null) {
      final Map<String, dynamic> prefsMap = 
          Map<String, dynamic>.from((decodePreferences(prefsString)));
      _preferences = Preferences.fromMap(prefsMap);
    } else {
      _preferences = Preferences();
    }
    
    notifyListeners();
  }

  /// Salva as preferências no armazenamento local
  /// 
  /// Atualiza as preferências atuais e persiste-as no SharedPreferences
  Future<void> savePreferences(Preferences newPreferences) async {
    _preferences = newPreferences;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, encodePreferences(_preferences.toMap()));
    
    notifyListeners();
  }

  // Métodos para alternar preferências
  /// Alterna a configuração de vibração
  Future<void> toggleVibration() async {
    _preferences.vibrationEnabled = !_preferences.vibrationEnabled;
    await _saveCurrentPreferences();
  }

  /// Alterna a configuração de som
  Future<void> toggleSound() async {
    _preferences.soundEnabled = !_preferences.soundEnabled;
    await _saveCurrentPreferences();
  }

  /// Alterna a configuração de banner
  Future<void> toggleBanner() async {
    _preferences.bannerEnabled = !_preferences.bannerEnabled;
    await _saveCurrentPreferences();
  }

  /// Alterna o modo crítico
  Future<void> toggleCriticalMode() async {
    _preferences.criticalMode = !_preferences.criticalMode;
    await _saveCurrentPreferences();
  }

  /// Salva as preferências atuais no armazenamento local
  Future<void> _saveCurrentPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, encodePreferences(_preferences.toMap()));
  }

  // Métodos auxiliares para codificar/decodificar preferências para armazenamento
  /// Codifica as preferências para armazenamento
  /// 
  /// Converte o mapa de preferências em uma string para armazenamento
  String encodePreferences(Map<String, dynamic> preferences) {
    // Codificação simples - em um aplicativo real, você pode querer usar JSON
    return preferences.toString();
  }

  /// Decodifica as preferências do armazenamento
  /// 
  /// Converte a string de preferências de volta para um mapa
  Map<String, dynamic> decodePreferences(String preferencesString) {
    // Decodificação simples - em um aplicativo real, você pode querer usar JSON
    // Esta é uma implementação simplificada
    final map = <String, dynamic>{};
    
    // Analisa a representação string de volta para um mapa
    // Esta é uma versão simplificada - em uma implementação real você usaria json.decode
    if (preferencesString.contains('vibrationEnabled')) {
      map['vibrationEnabled'] = preferencesString.contains('vibrationEnabled: true');
    }
    if (preferencesString.contains('soundEnabled')) {
      map['soundEnabled'] = preferencesString.contains('soundEnabled: true');
    }
    if (preferencesString.contains('bannerEnabled')) {
      map['bannerEnabled'] = preferencesString.contains('bannerEnabled: true');
    }
    if (preferencesString.contains('criticalMode')) {
      map['criticalMode'] = preferencesString.contains('criticalMode: true');
    }
    
    return map;
  }
}