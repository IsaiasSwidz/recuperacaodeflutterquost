/// Testes do Serviço de Banco de Dados
/// 
/// Esta suíte de testes verifica a funcionalidade do serviço de banco de dados,
/// incluindo inserção, recuperação e exclusão de eventos
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import '../lib/services/database_service.dart';
import '../lib/models/event.dart';

void main() {
  group('Testes do Serviço de Banco de Dados', () {
    late DatabaseService databaseService;

    setUp(() async {
      // Inicializa o serviço de banco de dados
      await DatabaseService.initialize();
      databaseService = DatabaseService();
    });

    test('deve inserir e recuperar um evento', () async {
      final event = Event(
        type: 'ALERT',
        timestamp: DateTime.now(),
        description: 'Evento de alerta de teste',
      );

      // Insere o evento
      final id = await databaseService.insertEvent(event);
      expect(id, greaterThan(0));

      // Recupera todos os eventos
      final events = await databaseService.getAllEvents();
      expect(events.length, 1);
      expect(events.first.type, 'ALERT');
      expect(events.first.description, 'Evento de alerta de teste');
    });

    test('deve armazenar múltiplos eventos', () async {
      final event1 = Event(
        type: 'ALERT',
        timestamp: DateTime.now(),
        description: 'Primeiro alerta',
      );

      final event2 = Event(
        type: 'INFO',
        timestamp: DateTime.now().add(const Duration(minutes: 1)),
        description: 'Segundo alerta',
      );

      await databaseService.insertEvent(event1);
      await databaseService.insertEvent(event2);

      final events = await databaseService.getAllEvents();
      expect(events.length, 2);

      // Verifica que os eventos estão ordenados por timestamp (mais recente primeiro)
      expect(events[0].description, 'Segundo alerta');
      expect(events[1].description, 'Primeiro alerta');
    });

    test('deve limpar todos os eventos', () async {
      final event = Event(
        type: 'ALERT',
        timestamp: DateTime.now(),
        description: 'Evento de teste a ser limpo',
      );

      await databaseService.insertEvent(event);
      var events = await databaseService.getAllEvents();
      expect(events.length, 1);

      await databaseService.clearAllEvents();
      events = await databaseService.getAllEvents();
      expect(events.length, 0);
    });
  });
}