/// Testes do Modelo de Evento
/// 
/// Esta suíte de testes verifica a funcionalidade do modelo de evento,
/// incluindo criação, conversão para mapa e representação em string
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/event.dart';

void main() {
  group('Testes do Modelo de Evento', () {
    test('deve criar um evento com todos os parâmetros', () {
      final now = DateTime.now();
      final event = Event(
        id: 1,
        type: 'ALERT',
        timestamp: now,
        description: 'Evento de teste',
      );

      expect(event.id, 1);
      expect(event.type, 'ALERT');
      expect(event.timestamp, now);
      expect(event.description, 'Evento de teste');
    });

    test('deve criar um evento com apenas parâmetros obrigatórios', () {
      final now = DateTime.now();
      final event = Event(
        type: 'INFO',
        timestamp: now,
      );

      expect(event.id, null);
      expect(event.type, 'INFO');
      expect(event.timestamp, now);
      expect(event.description, null);
    });

    test('deve converter evento para mapa e de volta', () {
      final now = DateTime.now();
      final originalEvent = Event(
        id: 1,
        type: 'WARNING',
        timestamp: now,
        description: 'Teste de evento convertido',
      );

      // Converte para mapa
      final map = originalEvent.toMap();
      expect(map['id'], 1);
      expect(map['type'], 'WARNING');
      expect(map['timestamp'], now.toIso8601String());
      expect(map['description'], 'Teste de evento convertido');

      // Converte de volta a partir do mapa
      final newEvent = Event.fromMap(map);
      expect(newEvent.id, 1);
      expect(newEvent.type, 'WARNING');
      expect(newEvent.timestamp, now);
      expect(newEvent.description, 'Teste de evento convertido');
    });

    test('deve lidar com diferentes tipos de evento', () {
      final alertEvent = Event(
        type: 'ALERT',
        timestamp: DateTime.now(),
      );
      final infoEvent = Event(
        type: 'INFO',
        timestamp: DateTime.now(),
      );
      final warningEvent = Event(
        type: 'WARNING',
        timestamp: DateTime.now(),
      );

      expect(alertEvent.type, 'ALERT');
      expect(infoEvent.type, 'INFO');
      expect(warningEvent.type, 'WARNING');
    });

    test('deve ter representação em string correta', () {
      final event = Event(
        id: 5,
        type: 'TEST',
        timestamp: DateTime(2023, 1, 1, 12, 0),
        description: 'Descrição de teste',
      );

      final expectedString = 'Evento(id: 5, tipo: TEST, timestamp: 2023-01-01 12:00:00.000, descricao: Descricao de teste)';
      expect(event.toString(), expectedString);
    });
  });
}