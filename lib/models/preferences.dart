/// Modelo de Preferências - Configurações do usuário
/// 
/// Esta classe representa as preferências do usuário para notificações,
/// incluindo vibração, som, banner e modo crítico
class Preferences {
  bool vibrationEnabled;
  bool soundEnabled;
  bool bannerEnabled;
  bool criticalMode;

  Preferences({
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.bannerEnabled = true,
    this.criticalMode = false,
  });

  /// Converte o objeto Preferences para um mapa
  /// 
  /// Usado para persistência com SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'soundEnabled': soundEnabled,
      'bannerEnabled': bannerEnabled,
      'criticalMode': criticalMode,
    };
  }

  /// Cria um objeto Preferences a partir de um mapa
  /// 
  /// Usado para converter dados do SharedPreferences para objeto
  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      vibrationEnabled: map['vibrationEnabled'] ?? true,
      soundEnabled: map['soundEnabled'] ?? true,
      bannerEnabled: map['bannerEnabled'] ?? true,
      criticalMode: map['criticalMode'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Preferencias(vibracaoHabilitada: $vibrationEnabled, somHabilitado: $soundEnabled, bannerHabilitado: $bannerEnabled, modoCritico: $criticalMode)';
  }
}