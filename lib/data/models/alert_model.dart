class AlertModel {
  final int? id;
  final String type;
  final DateTime triggerTime;
  final DateTime? processedTime;
  final bool isCritical;
  
  AlertModel({
    this.id,
    required this.type,
    required this.triggerTime,
    this.processedTime,
    this.isCritical = false,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'triggerTime': triggerTime.toIso8601String(),
      'processedTime': processedTime?.toIso8601String(),
      'isCritical': isCritical ? 1 : 0,
    };
  }
  
  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'],
      type: map['type'],
      triggerTime: DateTime.parse(map['triggerTime']),
      processedTime: map['processedTime'] != null 
          ? DateTime.parse(map['processedTime']) 
          : null,
      isCritical: map['isCritical'] == 1,
    );
  }
}