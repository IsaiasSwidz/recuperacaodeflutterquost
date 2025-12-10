/// Modelo de Evento - Representa um evento de alerta no sistema
/// 
/// Esta classe representa um evento registrado no sistema de monitoramento,
/// contendo informações como tipo, timestamp e descrição do evento
class Event {
  final int? id;
  final String type;
  final DateTime timestamp;
  final String? description;

  Event({
    this.id,
    required this.type,
    required this.timestamp,
    this.description,
  });

  /// Converte o objeto Event para um mapa
  /// 
  /// Usado para persistência no banco de dados SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }

  /// Cria um objeto Event a partir de um mapa
  /// 
  /// Usado para converter dados do banco de dados para objeto
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
      description: map['description'],
    );
  }

  @override
  String toString() {
    return 'Evento(id: $id, tipo: $type, timestamp: $timestamp, descricao: $description)';
  }
}