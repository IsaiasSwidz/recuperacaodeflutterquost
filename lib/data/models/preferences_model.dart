class PreferencesModel {
  bool vibrationEnabled;
  bool soundEnabled;
  bool bannerEnabled;
  bool criticalMode;
  
  PreferencesModel({
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.bannerEnabled = true,
    this.criticalMode = false,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'vibrationEnabled': vibrationEnabled,
      'soundEnabled': soundEnabled,
      'bannerEnabled': bannerEnabled,
      'criticalMode': criticalMode,
    };
  }
  
  factory PreferencesModel.fromMap(Map<String, dynamic> map) {
    return PreferencesModel(
      vibrationEnabled: map['vibrationEnabled'] ?? true,
      soundEnabled: map['soundEnabled'] ?? true,
      bannerEnabled: map['bannerEnabled'] ?? true,
      criticalMode: map['criticalMode'] ?? false,
    );
  }
}